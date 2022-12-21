#!/bin/bash

echo "* Deploy K8s Dashboard ..."
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml

echo "* Create Admin User ..."
kubectl apply -f /shared/dashboard-resources/dashboard-admin-user.yml

echo "* Create Admin Role ..."
kubectl apply -f /shared/dashboard-resources/dashboard-admin-role.yml

echo "* Generate Dashboard Token ..."
kubectl apply -f /shared/dashboard-resources/admin-user-secret.yaml

echo "* Save the dashboard token in a file..."
kubectl describe secret -n kubernetes-dashboard admin-user-secret >> /shared/dashboard-resources/dashboard-token.txt