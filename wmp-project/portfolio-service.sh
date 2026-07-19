dnf install -y java-21-openjdk-devel

useradd -r -s /bin/false appuser
mkdir -p /app

cp portfolio-service.service /etc/systemd/system/portfolio-service.service

curl -L -o /tmp/portfolio-service.tar.gz https://raw.githubusercontent.com/raghudevopsb88/wealth-project/main/artifacts/portfolio-service.tar.gz
cd /app
tar xzf /tmp/portfolio-service.tar.gz

cd /app
chmod +x gradlew
./gradlew bootJar --no-daemon -x test

cp /app/build/libs/*.jar /app/portfolio-service.jar
chown -R appuser:appuser /app
chmod o-rwx /app -R


systemctl daemon-reload
systemctl enable portfolio-service
systemctl start portfolio-service
