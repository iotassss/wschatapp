```sh
# ECRにログイン
aws ecr get-login-password --region ap-northeast-1 | docker login --username AWS --password-stdin 891377022391.dkr.ecr.ap-northeast-1.amazonaws.com

# Dockerイメージをビルド
docker build -t chatapp .

# ECRリポジトリにタグを付ける
docker tag chatapp:latest 891377022391.dkr.ecr.ap-northeast-1.amazonaws.com/chatapp:latest

# （未作成の場合）ECRリポジトリ作成
aws ecr create-repository --repository-name chatapp

# ECRにプッシュ
docker push 891377022391.dkr.ecr.ap-northeast-1.amazonaws.com/chatapp:latest
```

```sh
make all REGION=ap-northeast-1 ACCOUNT_ID=891377022391 REPOSITORY_NAME=chatapp4 IMAGE_TAG=latest
```
