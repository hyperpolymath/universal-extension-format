# API Protocol Compiler: GraphQL ↔ REST ↔ gRPC

## The Idea

**One abstract API definition** → **Live interpreter** for GraphQL, REST, and gRPC

```
┌────────────────────────────────────────┐
│ Abstract API Definition (A2ML)         │
│                                        │
│ @api:user-service                      │
│ operations:                            │
│   get_user: (id: UUID) -> User        │
│   create_user: (data: UserInput) -> User │
│   list_users: (filter: Filter) -> [User] │
└────────────────────────────────────────┘
                    ↓
┌────────────────────────────────────────┐
│ Live Interpreter (Runtime)             │
│ • Parses abstract operations           │
│ • Routes to protocol adapters          │
│ • Translates on-the-fly                │
└────────────────────────────────────────┘
          ↓           ↓           ↓
    ┌─────────┐ ┌─────────┐ ┌─────────┐
    │ GraphQL │ │  REST   │ │  gRPC   │
    │ Endpoint│ │Endpoints│ │ Service │
    └─────────┘ └─────────┘ └─────────┘
```

## Example: User Service

### Abstract Definition

```a2ml
@api:user-service
version: 1.0.0
protocol: multi

@entities:
User:
  - id: UUID (required)
  - name: String (required)
  - email: Email (required, unique)
  - created_at: DateTime (auto)

Filter:
  - name: String (optional)
  - email: String (optional)
  - limit: Int (optional, default: 10)
@end

@operations:
## Abstract operations (protocol-agnostic)
get_user:
  - input: { id: UUID }
  - output: User | NotFound
  - idempotent: true
  - cache: 5min

create_user:
  - input: { name: String, email: Email }
  - output: User | ValidationError
  - idempotent: false
  - requires: [authenticated]

list_users:
  - input: Filter
  - output: [User]
  - idempotent: true
  - pagination: cursor-based
@end

@protocols:
## How to expose each operation
graphql:
  enabled: true
  path: /graphql
  introspection: dev-only

rest:
  enabled: true
  base_path: /api/v1
  versioning: url

grpc:
  enabled: true
  port: 50051
  reflection: true
@end
```

### Generated Outputs (Live Interpreter)

#### 1. GraphQL Schema (Auto-Generated)

```graphql
type User {
  id: ID!
  name: String!
  email: String!
  createdAt: DateTime!
}

input FilterInput {
  name: String
  email: String
  limit: Int = 10
}

type Query {
  getUser(id: ID!): User
  listUsers(filter: FilterInput): [User!]!
}

type Mutation {
  createUser(name: String!, email: String!): User!
}

# Error handling
union UserResult = User | NotFoundError | ValidationError
```

**Live Endpoint**: `POST /graphql`

```graphql
query {
  getUser(id: "123") {
    id
    name
    email
  }
}
```

#### 2. REST Endpoints (Auto-Generated)

```
GET    /api/v1/users/:id           # get_user
POST   /api/v1/users                # create_user
GET    /api/v1/users?filter=...    # list_users
```

**OpenAPI Spec** (also auto-generated):

```yaml
/api/v1/users/{id}:
  get:
    operationId: getUser
    parameters:
      - name: id
        in: path
        required: true
        schema: { type: string, format: uuid }
    responses:
      200:
        description: User found
        content:
          application/json:
            schema: { $ref: '#/components/schemas/User' }
      404:
        description: User not found

/api/v1/users:
  post:
    operationId: createUser
    requestBody:
      required: true
      content:
        application/json:
          schema:
            type: object
            required: [name, email]
            properties:
              name: { type: string }
              email: { type: string, format: email }
```

#### 3. gRPC Proto (Auto-Generated)

```protobuf
syntax = "proto3";

package user_service;

message User {
  string id = 1;
  string name = 2;
  string email = 3;
  google.protobuf.Timestamp created_at = 4;
}

message GetUserRequest {
  string id = 1;
}

message CreateUserRequest {
  string name = 1;
  string email = 2;
}

message ListUsersRequest {
  optional string name = 1;
  optional string email = 2;
  int32 limit = 3;
}

message ListUsersResponse {
  repeated User users = 1;
}

service UserService {
  rpc GetUser(GetUserRequest) returns (User);
  rpc CreateUser(CreateUserRequest) returns (User);
  rpc ListUsers(ListUsersRequest) returns (ListUsersResponse);
}
```

**Live Endpoint**: `grpc://localhost:50051`

```go
client := pb.NewUserServiceClient(conn)
user, err := client.GetUser(ctx, &pb.GetUserRequest{Id: "123"})
```

## Live Interpreter Architecture

### Runtime Components

```elixir
# Elixir-based live interpreter
defmodule APIInterpreter do
  @moduledoc """
  Live interpreter that routes API calls to the appropriate protocol adapter
  """

  def handle_request(protocol, operation, params) do
    # 1. Parse abstract operation
    operation_def = Registry.get_operation(operation)

    # 2. Validate input (Nickel contracts)
    :ok = validate_params(params, operation_def.input_schema)

    # 3. Route to protocol adapter
    case protocol do
      :graphql -> GraphQLAdapter.execute(operation_def, params)
      :rest -> RESTAdapter.execute(operation_def, params)
      :grpc -> GRPCAdapter.execute(operation_def, params)
    end

    # 4. Transform response
    |> format_response(protocol)
    |> cache_if_idempotent(operation_def)
  end
end
```

### Protocol Adapters

```elixir
defmodule GraphQLAdapter do
  def execute(%Operation{name: "get_user"}, %{id: id}) do
    # GraphQL-specific execution
    # Query resolver already bound to abstract operation
    UserService.get_user(id)
  end
end

defmodule RESTAdapter do
  def execute(%Operation{name: "get_user"}, %{id: id}) do
    # REST-specific execution
    # Same underlying logic, different HTTP semantics
    UserService.get_user(id)
    |> format_as_json()
    |> add_rest_headers()
  end
end

defmodule GRPCAdapter do
  def execute(%Operation{name: "get_user"}, %{id: id}) do
    # gRPC-specific execution
    # Same underlying logic, protobuf serialization
    UserService.get_user(id)
    |> encode_protobuf()
  end
end
```

## Protocol Translation (Live)

### Same Call, Three Protocols

**GraphQL:**
```graphql
POST /graphql
{
  query: "{ getUser(id: \"123\") { name email } }"
}
```

**REST:**
```http
GET /api/v1/users/123
Accept: application/json
```

**gRPC:**
```
UserService.GetUser({id: "123"})
```

**All three** → Same underlying operation → Same business logic → Different wire formats

## Advanced Features

### 1. Protocol Bridging (Live)

Client uses GraphQL, backend uses gRPC:

```
GraphQL Request
    ↓
Interpreter parses to abstract operation
    ↓
Routes to gRPC adapter
    ↓
Calls gRPC backend
    ↓
Translates response back to GraphQL
    ↓
Returns to client
```

**Example:**
```graphql
# Client sends GraphQL
query { getUser(id: "123") { name } }

# Interpreter translates to gRPC call
UserService.GetUser({id: "123"})

# Backend returns protobuf
User { id: "123", name: "Alice", ... }

# Interpreter translates back to GraphQL JSON
{ "data": { "getUser": { "name": "Alice" } } }
```

### 2. Multi-Protocol Federation

**Service A** (GraphQL) + **Service B** (gRPC) → Unified API:

```a2ml
@federation:api-gateway

@services:
user-service:
  - protocol: graphql
  - endpoint: http://users.svc/graphql

order-service:
  - protocol: grpc
  - endpoint: orders.svc:50051

product-service:
  - protocol: rest
  - endpoint: http://products.svc/api/v1
@end

@composite-operations:
## Abstract operation that calls multiple services
get_user_orders:
  - input: { user_id: UUID }
  - steps:
      1. user = user-service.get_user(user_id)     # GraphQL
      2. orders = order-service.list_orders(user_id) # gRPC
      3. products = product-service.get_many(order.product_ids) # REST
  - output: { user: User, orders: [Order], products: [Product] }
@end
```

**Client calls ONE operation**, interpreter orchestrates THREE protocols!

### 3. Type-Safe Protocol Switching

```nickel
# Nickel contract ensures type compatibility
let APIOperation = {
  name | String,
  input_schema | Schema,
  output_schema | Schema,
  protocols | [| 'GraphQL, 'REST, 'gRPC |],
}

let validate_operation = fun op =>
  # Ensure operation is compatible with all enabled protocols
  std.array.all (fun proto =>
    check_protocol_compatibility(op, proto)
  ) op.protocols
```

## Integration with Existing Projects

### HAR + API Compiler Integration

**Use Case**: Deploy API infrastructure with multi-protocol support

```a2ml
@infrastructure:api-deployment
@api:user-service

## Infrastructure (HAR)
infrastructure:
  - deploy: kubernetes
  - expose: load-balancer
  - scaling: hpa

## API definition (API Compiler)
api:
  operations: [get_user, create_user, list_users]
  protocols: [graphql, rest, grpc]

@output:
## HAR generates Kubernetes manifests
kubernetes:
  deployment: user-service.yaml
  service: load-balancer.yaml

## API Compiler generates server code
elixir:
  graphql_schema: schema.ex
  rest_routes: router.ex
  grpc_service: service.proto
@end
```

### HTTP-Gateway + API Compiler Integration

**Use Case**: Enforce HTTP verb policies on REST endpoints

```a2ml
@api:user-service
@http-policy:embedded

## API operations
operations:
  get_user: GET /users/:id
  create_user: POST /users
  delete_user: DELETE /users/:id

## HTTP governance
http-policy:
  GET: { exposure: public }
  POST: { exposure: authenticated }
  DELETE: { exposure: internal, stealth: 404 }

@output:
## API Compiler generates endpoints
rest:
  routes: [
    GET /users/:id,
    POST /users,
    DELETE /users/:id
  ]

## HTTP-Gateway enforces policies
nginx:
  config: verb-policy.conf
  integrate_with: rest_routes
@end
```

## Existing Solutions vs. This Approach

| Tool | GraphQL | REST | gRPC | Live Interpreter | Formal Verification |
|------|---------|------|------|------------------|---------------------|
| **Swagger/OpenAPI** | ❌ | ✅ | ❌ | ❌ | ❌ |
| **GraphQL** | ✅ | ⚠️ (via resolvers) | ❌ | ❌ | ❌ |
| **gRPC-Gateway** | ❌ | ✅ | ✅ | ⚠️ (gRPC→REST only) | ❌ |
| **Buf** | ⚠️ (generate) | ⚠️ (generate) | ✅ | ❌ | ❌ |
| **This (API Compiler)** | ✅ | ✅ | ✅ | ✅ | ✅ (Nickel + Idris2) |

## Implementation Roadmap

### Phase 1: Basic Interpreter (3 months)
- [ ] A2ML API definition parser
- [ ] GraphQL schema generator
- [ ] REST endpoint generator
- [ ] gRPC proto generator
- [ ] Basic live interpreter (Elixir)

### Phase 2: Advanced Features (3 months)
- [ ] Protocol bridging (GraphQL ↔ REST ↔ gRPC)
- [ ] Multi-protocol federation
- [ ] Caching layer
- [ ] Validation (Nickel contracts)

### Phase 3: Formal Verification (6 months)
- [ ] Idris2 proofs of protocol compatibility
- [ ] Type-safe transformations
- [ ] Correctness guarantees

## The Hyperpolymath Compiler Family

```
1. UXF - Extensions → Many platforms
2. HAR - Infrastructure → Many IaC tools
3. HTTP-Gateway - Policies → Many enforcement backends
4. API Compiler - APIs → Many protocols (NEW!)
```

All sharing:
- A2ML (source format)
- K9-SVC (self-validation)
- Nickel (type safety)
- Idris2 (formal proofs)

## Next Steps

Want me to:
1. **Create API-compiler repo** using rsr-template-repo?
2. **Prototype live interpreter** (GraphQL + REST from one source)?
3. **Show how it integrates** with HAR + HTTP-Gateway?
4. **Build proof-of-concept** for a real API?
