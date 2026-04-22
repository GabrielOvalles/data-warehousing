# 🌐 Bilingual README / README Bilingüe

This README file is available in both English and Spanish to ensure accessibility for a broader audience.  
Este archivo README está disponible en inglés y español para garantizar accesibilidad a una audiencia más amplia.

Please note that this applies only to the README documentation and not necessarily to the entire repository.  
Tenga en cuenta que esto aplica únicamente al archivo README y no necesariamente a todo el repositorio.

Kindly refer to the section corresponding to your preferred language.  
Por favor, diríjase a la sección correspondiente según su idioma de preferencia.

# 🏗️ Data Warehouse Project

## 📖 Description
This project implements a Data Warehouse using a layered architecture with `.csv` files as the data source. It follows an ELT (Extract, Load, Transform) approach to process and prepare data for analytics.

---

## 🎯 Objective
To centralize data from multiple `.csv` files, clean and transform it, and make it available for analysis and reporting.

---

## 🧱 Data Warehouse Architecture

The project is divided into three main layers:

### 🥉 Bronze Layer (Raw Data)
- Data is ingested directly from `.csv` files.
- No transformations are applied.
- Data is stored as-is.

**Purpose:** Historical storage and data traceability.

---

### 🥈 Silver Layer (Cleaned Data)
- Data cleaning and transformation processes:
  - Duplicate removal
  - Handling missing values
  - Data type corrections
  - Format standardization
  - Business rule application

**Purpose:** Ensure data quality and consistency.

---

### 🥇 Gold Layer (Business-Ready Data)
- No physical tables are created.
- **Views** are created to join and integrate Silver layer tables.
- Data is ready for BI tools and analytics.

**Purpose:** Deliver optimized data for decision-making.

---

## 🔄 Process Flow (ELT)

1. **Extract:** Data is extracted from `.csv` files.
2. **Load:** Data is loaded into the Bronze Layer without transformation.
3. **Transform:** Data is cleaned and transformed in the Silver Layer.
4. **Serve:** Final data is exposed through views in the Gold Layer.

---

## 📂 Project Structure
data-warehouse-project/
│
├── data/
│ └── raw_csv/ # Source files (.csv)
│
├── sql/
│ ├── bronze/ # Load scripts
│ ├── silver/ # Transformation scripts
│ └── gold/ # View scripts
│
├── docs/ # Documentation
├── utils/ # Helper scripts
├── README.md
└── requirements.txt


---

## ⚙️ Technologies Used
- Database: (PostgreSQL / SQL Server / MySQL)
- Language: SQL
- Data Source: `.csv` files
- Approach: ELT

---

## ✅ Benefits
- Centralized and structured data
- Improved data quality
- Easier analysis and decision-making
- Scalable and maintainable

---

## 📝 Notes
This project can be adapted to different data sources and business needs.
----------------------------------------------------------------------------------

# 🏗️ Data Warehouse Project

## 📖 Descripción
Este proyecto implementa un Data Warehouse basado en una arquitectura por capas utilizando archivos `.csv` como fuente de datos. Se sigue un enfoque ELT (Extract, Load, Transform) para procesar y preparar la información para análisis.

---

## 🎯 Objetivo
Centralizar datos provenientes de múltiples archivos `.csv`, limpiarlos, transformarlos y disponibilizarlos para análisis y reportes.

---

## 🧱 Arquitectura del Data Warehouse

El proyecto está dividido en tres capas principales:

### 🥉 Bronze Layer (Datos Crudos)
- Se cargan los datos directamente desde archivos `.csv`.
- No se aplican transformaciones.
- Se mantiene la data tal cual se recibe.

**Propósito:** Almacenamiento histórico y trazabilidad de los datos.

---

### 🥈 Silver Layer (Datos Limpios)
- Se realiza el proceso de limpieza y transformación de datos:
  - Eliminación de duplicados
  - Manejo de valores nulos
  - Corrección de tipos de datos
  - Estandarización de formatos
  - Aplicación de reglas de negocio

**Propósito:** Garantizar calidad y consistencia de los datos.

---

### 🥇 Gold Layer (Datos para Negocio)
- No se crean tablas físicas.
- Se crean **vistas** que integran y relacionan las tablas de la capa Silver.
- Datos listos para consumo por herramientas de BI y análisis.

**Propósito:** Proveer datos optimizados para la toma de decisiones.

---

## 🔄 Flujo del Proceso (ELT)

1. **Extract:** Extracción de datos desde archivos `.csv`.
2. **Load:** Carga de datos en la Bronze Layer sin transformación.
3. **Transform:** Limpieza y transformación en la Silver Layer.
4. **Serve:** Exposición de datos mediante vistas en la Gold Layer.

---

## 📂 Estructura del Proyecto

data-warehouse-project/
│
├── data/
│ └── raw_csv/ # Archivos fuente (.csv)
│
├── sql/
│ ├── bronze/ # Scripts de carga
│ ├── silver/ # Scripts de transformación
│ └── gold/ # Scripts de vistas
│
├── docs/ # Documentación
├── utils/ # Scripts auxiliares
├── README.md
└── requirements.txt

---
## ⚙️ Tecnologías Utilizadas
- Base de Datos: (SQL Server)
- Lenguaje: SQL
- Fuente de datos: Archivos `.csv`
- Enfoque: ELT

---

## ✅ Beneficios
- Datos centralizados y estructurados
- Mejora en la calidad de la información
- Facilita el análisis y la toma de decisiones
- Escalable y mantenible

---

## 📝 Notas
Este proyecto puede adaptarse a diferentes fuentes de datos y necesidades de negocio.
-------------------------------------------------------------------------------------------------------
