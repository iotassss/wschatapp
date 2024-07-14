# Default values
REGION ?= ap-northeast-1
ACCOUNT_ID ?= 891377022391
REPOSITORY_NAME ?= chatapp
IMAGE_TAG ?= latest

ECR_URI := $(ACCOUNT_ID).dkr.ecr.$(REGION).amazonaws.com/$(REPOSITORY_NAME):$(IMAGE_TAG)

.PHONY: login build tag create-repo push all

# ECRにログイン
login:
	@echo "Logging in to ECR..."
	aws ecr get-login-password --region $(REGION) | docker login --username AWS --password-stdin $(ACCOUNT_ID).dkr.ecr.$(REGION).amazonaws.com

# Dockerイメージをビルド
build:
	@echo "Building Docker image..."
	docker build -t $(REPOSITORY_NAME) .

# ECRリポジトリにタグを付ける
tag:
	@echo "Tagging Docker image..."
	docker tag $(REPOSITORY_NAME):latest $(ECR_URI)

# （未作成の場合）ECRリポジトリ作成
create-repo:
	@echo "Checking if repository exists..."
	@if ! aws ecr describe-repositories --repository-names $(REPOSITORY_NAME) --region $(REGION) > /dev/null 2>&1; then \
		echo "Repository does not exist. Creating repository..."; \
		aws ecr create-repository --repository-name $(REPOSITORY_NAME) --region $(REGION); \
	else \
		echo "Repository already exists."; \
	fi

# ECRにプッシュ
push:
	@echo "Pushing Docker image to ECR..."
	docker push $(ECR_URI)

# All steps
all: login build tag create-repo push
	@echo "All steps completed."
