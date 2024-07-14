# ベースイメージ
FROM golang:1.21 as builder

# ワーキングディレクトリを設定
WORKDIR /app

# モジュールファイルをコピーして依存関係をインストール
COPY go.mod go.sum ./
RUN go mod download

# ソースコードをコピー
COPY . .

# バイナリをビルド
RUN GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -o /main main.go

# 2つ目のステージ：ランタイムイメージ
FROM public.ecr.aws/lambda/go:1

# ビルドしたバイナリをコピー
COPY --from=builder /main /var/task/main

# Lambdaのエントリーポイントを指定
CMD [ "main" ]
