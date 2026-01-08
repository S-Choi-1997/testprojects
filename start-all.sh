#!/bin/bash

echo "Starting all services..."

# Start nginx
echo "Starting nginx..."
nginx -c /workspace/nginx.conf

# Start Spring Boot
echo "Starting Spring Boot..."
cd /workspace/project2
java -jar build/libs/demo-0.0.1-SNAPSHOT.jar > /tmp/spring-boot.log 2>&1 &
SPRING_PID=$!
echo "Spring Boot started with PID: $SPRING_PID"

# Start Express
echo "Starting Express..."
cd /workspace/project3
npm start > /tmp/express.log 2>&1 &
EXPRESS_PID=$!
echo "Express started with PID: $EXPRESS_PID"

# Start React dev server
echo "Starting React dev server..."
cd /workspace/project1
npm run dev > /tmp/react.log 2>&1 &
REACT_PID=$!
echo "React started with PID: $REACT_PID"

echo ""
echo "All services started!"
echo "========================"
echo "Access via: http://testing.albl.cloud"
echo ""
echo "Endpoints:"
echo "  - Frontend (React):      /"
echo "  - Spring Boot API:       /api/spring"
echo "  - Express API:           /api/express"
echo "  - Express Health:        /api/express/health"
echo ""
echo "Logs:"
echo "  - Spring Boot: tail -f /tmp/spring-boot.log"
echo "  - Express:     tail -f /tmp/express.log"
echo "  - React:       tail -f /tmp/react.log"
echo ""

# Keep script running
wait
