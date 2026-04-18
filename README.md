# Predicción de Código HTS de 6 Dígitos a partir de Lenguaje Natural

Este proyecto tiene como misión desarrollar un sistema avanzado de predicción del código HTS (Harmonized Tariff Schedule) de 6 dígitos, empleando técnicas de procesamiento de lenguaje natural (NLP) para analizar y comprender entradas textuales proporcionadas por el usuario. Aprovechando la riqueza semántica y la capacidad de inferencia de modelos de lenguaje de última generación, este sistema está diseñado para optimizar y automatizar el proceso de clasificación arancelaria de productos en el comercio internacional.

Al permitir la interpretación inteligente de descripciones en lenguaje natural, esta solución no solo reduce la complejidad inherente a la clasificación de productos dentro de los marcos regulatorios globales, sino que también mejora la precisión y la eficiencia del proceso. Este enfoque innovador tiene el potencial de transformar la forma en que las empresas navegan por las complejidades del comercio internacional, reduciendo la incertidumbre asociada con los códigos HTS y facilitando el cumplimiento normativo con una precisión excepcional.

![RAG-Index creation](https://github.com/user-attachments/assets/d00770fd-9688-4319-b037-b2e592f85758)

## Introducción

Este proyecto implementa un sistema de **Recuperación Aumentada con Generación (RAG)**. RAG combina técnicas de **búsqueda basada en recuperación** y **generación de texto** mediante modelos de lenguaje natural. La idea principal es que el modelo de generación se apoya en información relevante recuperada de una base de conocimiento o documentos externos para generar respuestas más precisas y contextuales a las preguntas del usuario.

## ¿Cómo funciona RAG?

El sistema RAG consta de dos componentes principales:

1. **Recuperador de información**: 
   - Cuando se recibe una consulta, el sistema busca en una base de datos (puede ser una base de conocimientos, documentos, etc.) para recuperar los fragmentos más relevantes. Esta base se encuentra localmente en Chromadb, donde los documentos han sido previamente indexados. 
   
2. **Generador basado en un modelo de lenguaje**: 
   - Una vez que se recuperan los fragmentos relevantes, estos se pasan al generador (como un modelo de lenguaje basado en Transformer, por ejemplo, GPT) que utiliza esa información para generar una respuesta coherente y precisa a la consulta inicial.

### Pasos de procesamiento:

1. **Input del usuario**: El sistema recibe una consulta en lenguaje natural.
2. **Recuperación de documentos**: Se buscan los documentos o fragmentos más relevantes a la consulta.
3. **Incorporación de la información recuperada**: La información obtenida se introduce al modelo de lenguaje.
4. **Generación de respuesta**: El modelo genera una respuesta final que integra tanto el contexto de la consulta como la información recuperada.
5. **Devolución de la respuesta al usuario**: Codigo HTS a 6 digitos (Capitulo, parte y subparte) o bien, 3 posibles codigos a ser utilizados en caso de recibir una entrada muy ambigüa.

## Tabla de Contenidos

- [Requisitos Previos](#requisitos-previos)
- [Instalación](#instalación)
  - [1. Clonar el Repositorio](#1-clonar-el-repositorio)
  - [2. Instalar Paquetes Necesarios](#2-instalar-paquetes-necesarios)
  - [3. Instalar Ollama y el Modelo Llama 3](#3-instalar-ollama-y-el-modelo-llama-3)
- [Contribuciones](#contribuciones)
- [Licencia](#licencia)

## Requisitos Previos

- **Python 3.11** instalado en su sistema.
- **Google Chrome** instalado.
- **Ollama** y el modelo **Llama 3** instalados. (Ver sección de instalación)
- **CUDA 11.6** instalado si utiliza una GPU NVIDIA compatible.

## Instalación

### 1. Clonar el Repositorio

Abra una terminal y clone el repositorio:

```bash
git clone https://github.com/usuario/nombre-del-repositorio.git
cd nombre-del-repositorio
```

### 2. Instalar Paquetes Necesarios

```bash
mvn clean install
```

### 3. Instalar Ollama y el Modelo Llama 3

Este proyecto utiliza **Ollama** para ejecutar el modelo **Llama 3** localmente. Siga estos pasos para instalar ambos:

#### a. Instalar Ollama

Visite el sitio oficial de Ollama: [https://ollama.com/](https://ollama.com/)

- **En macOS:**

  Ollama se puede instalar utilizando **Homebrew**:

  ```bash
  brew install ollama/tap/ollama
  ```

- **En Windows y Linux:**

  A partir de octubre de 2024, Ollama ofrece soporte completo para Windows y Linux. Por favor, consulte la [documentación oficial](https://github.com/jmorganca/ollama#readme) para obtener instrucciones específicas y actualizaciones.

#### b. Instalar el Modelo Llama 3

Una vez que Ollama esté instalado, puede descargar e instalar el modelo **Llama 3** ejecutando:

```bash
ollama pull llama3
```

Este comando descargará el modelo y lo preparará para su uso con Ollama.

## Contribuciones

¡Las contribuciones son bienvenidas! Por favor, siga estos pasos:

1. Haga un fork del repositorio.
2. Cree una rama con una descripción clara de su función o corrección: `git checkout -b mi-nueva-funcionalidad`.
3. Haga commit de sus cambios: `git commit -am 'Agrega nueva funcionalidad'`.
4. Empuje a la rama: `git push origin mi-nueva-funcionalidad`.
5. Abra un Pull Request en GitHub.

## Derechos y Uso Académico

Este proyecto ha sido desarrollado como parte de un trabajo académico para el Tec de Monterrey en el curso de "Proyecto Integrador" bajo la supervisión de Horacio Martínez Alfaro. Su uso está limitado exclusivamente a fines educativos y no se autoriza su explotación comercial ni su distribución fuera del ámbito académico sin el consentimiento expreso de los autores y la universidad.

Cualquier referencia o reutilización de este trabajo deberá ser debidamente citada y acreditada a los autores originales. Para consultas o solicitudes de uso, por favor contactar con los autores a través de los canales oficiales de la universidad.
