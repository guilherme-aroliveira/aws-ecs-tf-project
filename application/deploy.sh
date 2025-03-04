#! /bin/sh

SERVICE_NAME="springbootapp"
SERVICE_TAG="v1"
ECR_REPO_URL="${ECR_repo}/${SERVICE_NAME}"

if [ "$1" = "build" ];then
    echo "Building the application..."
    cd ..
    sh mvnw clean install

elif [ "$1" = "dockerize" ]; then
    find ../target/ -type f \( -name "*.jar" -not -name "*sources.jar" \) -exec cp {} ../application/$SERVICE_NAME.jar \;
    $(aws ecr get-login --no-include-email --region us-east-1)
    aws ecr create-repository --repository-name ${SERVICE_NAME:?} || true
    docker build -t ${SERVICE_NAME}:${SERVICE_TAG} .
    docker tag ${SERVICE_NAME}:${SERVICE_TAG}
    docker push ${ECR_REPO_URL}:${SERVICE_TAG}

elif [ "$1" = "plan" ]; then
    cd /$HOME/Projects/github/aws-ecs-tf-project/terraform/environment/
    terraform init --backend-config="aws.conf"
    terraform plan

elif [ "$1" = "deploy" ];then
    cd /$HOME/Projects/github/aws-ecs-tf-project/terraform/environment/
    terraform init --backend-config="aws.conf"
    terraform apply -auto-approve

elif [ "$1" = "destroy"];then
    cd /$HOME/Projects/github/aws-ecs-tf-project/terraform/environment/
    terraform init --backend-config="aws.conf"
    terraform destroy -auto-approve
fi