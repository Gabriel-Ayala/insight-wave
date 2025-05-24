echo "🚀 Scaffolding Real-Time Analytics Dashboard..."

echo "Creating service directories ..."


mkdir -p backend/auth-service/src/{routes,middleware,models,controllers,config}
mkdir -p backend/auth-service/test

mkdir -p backend/query-service/src/{api,middleware,controllers,db}
mkdir -p backend/query-service/test

mkdir -p backend/websocket-service/src/{listeners,sockets,utils}
mkdir -p backend/websocket-service/test

mkdir -p backend/etl-service/src/{connectors,jobs,models,utils}



# mkdir -p frontend/src/{components,pages,hooks,services,types,utils}


mkdir -p .github/workflows
mkdir -p .github/assets




