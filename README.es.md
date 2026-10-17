# Commerce Sales Performance Analysis

**Excel · SQL (PostgreSQL) · Tableau**

Análisis end-to-end de un negocio retail multiproducto durante 2023. El negocio generó **172.985 €** de revenue, pero **el 41,8 % de los pedidos se cancelaron o devolvieron**, lo que supone **114.255 € de revenue perdido** (el 39,7 % del bruto).

*Read in English: [README.md](README.md)*

![Dashboard de Tableau](images/dashboard.jpg)

**[Ver el dashboard interactivo en Tableau Public ↗](https://public.tableau.com/app/profile/ana.fern.ndez.arias/viz/DashboardCommercePerfomanceAnalysis/Dashboard)**

---

## Problema de negocio

Un retail multicanal (Online, Mobile, Store) que vende Electronics, Clothing, Sports y Beauty quiere saber:

- Qué impulsa su revenue (categorías, canales, ciudades, clientes)
- Dónde está perdiendo dinero
- Qué acciones debería priorizar

## Proceso

| Paso | Herramienta | Qué se hizo |
| --- | --- | --- |
| 1. Preparación de datos | Excel | Enriquecimiento de la tabla de ventas original de Kaggle con las tablas Customers y Products, campos derivados y reglas de negocio |
| 2. Análisis exploratorio | PostgreSQL | Revisión de calidad del dato y preguntas de negocio en 4 bloques: rendimiento, fuentes de revenue, clientes y operativa |
| 3. Visualización | Tableau | Dashboard interactivo con KPIs, evolución mensual, mapa, reparto por categoría y segmentos de cliente como filtros cruzados |

## Dataset

Parte del Retail Sales Dataset (Kaggle), adaptado y enriquecido de forma sintética para simular un entorno de negocio realista. Los datos se generan de forma aleatoria a partir de unos criterios teóricos previos; las cifras indicadas son la distribución final obtenida.

| Tabla | Filas | Contenido |
| --- | --- | --- |
| `transactions` | 1.000 | Fecha, cliente, producto, cantidad, precio, importe total, canal, estado del pedido, método de pago |
| `customers` | 260 | Género, edad (18–70), ciudad, suscripción (≈16 % suscritos), fecha de registro (2019–2023) |
| `products` | 175 | Categoría (Clothing 42 % · Beauty 25 % · Electronics 17 % · Sports 17 %), price segment, precio base |

Se introducen valores NULL de forma controlada (≈1 % por campo; 8,2 % en `customer_id`). Fórmulas de Excel usadas para generar los datos: [excel/data_generation_formulas.md](excel/data_generation_formulas.md).

## Hallazgos principales

| Hallazgo | Cifra |
| --- | --- |
| Revenue perdido por cancelaciones y devoluciones | 114.255 € (39,7 % del bruto, 288.140 €) |
| Tasa de cancelación | 17,7 % |
| Tasa de devolución | 24,1 % (Clothing, la más alta: 28,3 %) |
| Concentración del revenue en clientes VIP | 30 clientes VIP (14 %) generan el 37 % del revenue con cliente identificado |
| Principal driver de revenue | Electronics, 39,6 % del revenue |
| Negocio e-commerce | Online + Mobile = 85,9 % del revenue |
| Beauty: mucho volumen, ticket bajo | 2.ª categoría en número de pedidos, pero ticket medio de 130 € (Electronics: 611 €) |
| Calidad del dato | El 9 % del revenue no tiene cliente asignado |

## Recomendaciones

| Prioridad | Acción | Objetivo | Impacto estimado |
| --- | --- | --- | --- |
| 1 | Reducir cancelaciones: analizar por qué abandona el cliente, en todos los canales | 17,7 % → menos del 12 % | ≈ +15.200 € |
| 2 | Reducir devoluciones, empezando por Clothing (guía de tallas, fichas de producto) | 24,1 % → menos del 18 % | ≈ +17.200 € |
| 3 | Programa de fidelización para clientes VIP | Retener a los 30 VIP | Protege el 37 % del revenue |
| 4 | Subir el ticket de Beauty con packs y venta cruzada | Ticket medio por encima de 130 € | A medir |
| 5 | Mejorar la captura de datos de cliente | `customer_id` NULL por debajo del 2 % | Hace analizable el 9 % del revenue |

Cumplir los objetivos 1 y 2 recuperaría unos **32.400 € (+18,7 % de revenue)**. Estimación: pedidos que dejarían de perderse × ticket medio de cada tipo de pedido (cancelados 266,57 €, devueltos 281,69 €).

## Scripts SQL

Se ejecutan en orden sobre una base de datos PostgreSQL. Cada query empieza con la pregunta de negocio y el resultado obtenido.

| Script | Contenido |
| --- | --- |
| [00_schema.sql](sql/00_schema.sql) | Creación de tablas y carga de los CSV |
| [01_data_quality.sql](sql/01_data_quality.sql) | NULL por columna, duplicados, fechas fuera de rango, revenue sin cliente |
| [02_business_performance.sql](sql/02_business_performance.sql) | Revenue total, ticket medio, evolución mensual |
| [03_revenue_drivers.sql](sql/03_revenue_drivers.sql) | Revenue por categoría, price segment, canal y ciudad |
| [04_customer_segmentation.sql](sql/04_customer_segmentation.sql) | Segmentación Basic / Regular / VIP con peso en el revenue |
| [05_operational_efficiency.sql](sql/05_operational_efficiency.sql) | Tasas de cancelación y devolución, revenue perdido, tasas por categoría y canal |

Técnicas SQL: CTE, CASE, JOIN, agregaciones, funciones de ventana (`SUM() OVER ()`), tratamiento de NULL.

## Cómo reproducirlo

1. Crea una base de datos PostgreSQL (por ejemplo, `commerce_retail_sales`).
2. Abre `sql/00_schema.sql`, sustituye `<path>` por la ruta local de la carpeta `data` y ejecútalo. Resultado esperado: 260 clientes, 175 productos y 1.000 transacciones.
3. Ejecuta los scripts del `01` al `05` en orden.

## Limitaciones

- Los datos son parcialmente sintéticos: los hallazgos ilustran el proceso de análisis, no una empresa real.
- Solo hay un año de datos, así que no se puede confirmar estacionalidad.
- Dos transacciones con fecha de enero de 2024 se mantienen y se documentan como outlier.

---

**Ana F. Arias** · Junior Data Analyst · [Portfolio](https://claude.ai/artifact/GaLgmhGKkzFVNMzFqkDSGp)
