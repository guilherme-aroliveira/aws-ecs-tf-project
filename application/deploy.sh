#! /bin/sh

AWS_ACCOUNT_ID=""
AWS_REGION="us-east-1"
SERVICE_NAME="springbootapp"
SERVICE_TAG="latest"
ECR_REPO_URL="${ECR_repo}/${SERVICE_NAME}"

if [ "$1" = "plan" ]; then
    cd /$HOME/Projects/github/aws-ecs-tf-project/terraform/environment/
    terraform init --backend-config="aws.conf"
    terraform plan

elif [ "$1" = "plan" ]; then
    cd /$HOME/Projects/github/aws-ecs-tf-project/terraform/environment/
    terraform init --backend-config="aws.conf"
    terraform plan

elif [ "$1" = "apply" ];then
    cd /$HOME/Projects/github/aws-ecs-tf-project/terraform/environment/
    terraform init --backend-config="aws.conf"
    terraform apply -auto-approve

elif [ "$1" = "build" ];then
    echo "Building the application..."
    cd ..
    sh mvnw clean install

elif [ "$1" = "dockerize" ]; then
    find ../target/ -type f \( -name "*.jar" -not -name "*sources.jar" \) -exec cp {} ../application/$SERVICE_NAME.jar \;
    aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com
    docker build -t ${SERVICE_NAME}:${SERVICE_TAG} .
    docker tag IMAGE_ID ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/REPO:${SERVICE_TAG}
    docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/REPO:${SERVICE_TAG}

elif [ "$1" = "destroy"];then
    cd /$HOME/Projects/github/aws-ecs-tf-project/terraform/environment/
    terraform init --backend-config="aws.conf"
    terraform destroy -auto-approve
fi