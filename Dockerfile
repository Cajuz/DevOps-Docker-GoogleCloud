#Image do DOCKER HUB: https://hub.docker.com/_/python
FROM python:3.10-slim-bullseye

# Define variáveis de ambiente para otimizar a execução do Python em contêineres.
# PYTHONDONTWRITEBYTECODE: Impede o Python de criar arquivos .pyc.
# PYTHONUNBUFFERED: Garante que os logs do Python sejam enviados diretamente para o terminal.
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Etapa 2: Define o diretório de trabalho dentro do contêiner
WORKDIR /app

# Etapa 3: Instalação das dependências
# Copiamos primeiro o requirements.txt para aproveitar o cache de camadas do Docker.
# As dependências só serão reinstaladas se este arquivo mudar.
COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Etapa 4: Copia o código da aplicação
COPY . . 
# O ". ." copia todo conteudo do diretória atual (onde o Dockerfile está localizado) para o diretório de trabalho /app no contêiner.

# Etapa 5: Expõe a porta que a aplicação usará
EXPOSE 8000

# Etapa 6: Comando para iniciar a aplicação quando o contêiner for executado
# Usamos --host 0.0.0.0 para tornar a API acessível de fora do contêiner.
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]
