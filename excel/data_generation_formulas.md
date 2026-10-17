# Data generation formulas (Excel)

The original Kaggle dataset only had a sales table. The Customers and Products tables and several transaction fields were generated in Excel with business rules, so the data stays logically consistent.

Values were generated randomly from theoretical criteria defined beforehand. The final distributions are the ones described in the README.

Formulas are shown in Spanish-locale Excel (as used in the project) and in English-locale Excel.

## 1. Price segment by product category

Each category can only take certain price segments.

```excel
=SI(B2="Electronics"; ELEGIR(ALEATORIO.ENTRE(1;3);"Medium";"Medium-Premium";"Premium");
 SI(B2="Clothing";    ELEGIR(ALEATORIO.ENTRE(1;3);"Low";"Low-Medium";"Medium");
 SI(B2="Beauty";      ELEGIR(ALEATORIO.ENTRE(1;2);"Low";"Low-Medium");
 SI(B2="Sports";      ELEGIR(ALEATORIO.ENTRE(1;2);"Medium";"Medium-Premium");
 ""))))
```

```excel
=IF(B2="Electronics", CHOOSE(RANDBETWEEN(1,3),"Medium","Medium-Premium","Premium"),
 IF(B2="Clothing",    CHOOSE(RANDBETWEEN(1,3),"Low","Low-Medium","Medium"),
 IF(B2="Beauty",      CHOOSE(RANDBETWEEN(1,2),"Low","Low-Medium"),
 IF(B2="Sports",      CHOOSE(RANDBETWEEN(1,2),"Medium","Medium-Premium"),
 ""))))
```

## 2. Base price by price segment

Random price within a range for each segment, always a multiple of 15.

| Segment | Range |
| --- | --- |
| Low | 15 – 45 € |
| Low-Medium | 60 – 90 € |
| Medium | 105 – 150 € |
| Medium-Premium | 165 – 240 € |
| Premium | 255 – 360 € |

One product falls outside its range: PROD108 (Electronics, Premium) at 650 €.

```excel
=SI(C2="Low";            15*ALEATORIO.ENTRE(1;3);
 SI(C2="Low-Medium";     15*ALEATORIO.ENTRE(4;6);
 SI(C2="Medium";         15*ALEATORIO.ENTRE(7;10);
 SI(C2="Medium-Premium"; 15*ALEATORIO.ENTRE(11;16);
 SI(C2="Premium";        15*ALEATORIO.ENTRE(17;24);
 "")))))
```

```excel
=IF(C2="Low",            15*RANDBETWEEN(1,3),
 IF(C2="Low-Medium",     15*RANDBETWEEN(4,6),
 IF(C2="Medium",         15*RANDBETWEEN(7,10),
 IF(C2="Medium-Premium", 15*RANDBETWEEN(11,16),
 IF(C2="Premium",        15*RANDBETWEEN(17,24),
 "")))))
```

## 3. Payment method conditioned by channel

Online and Mobile orders can be paid with Card, PayPal or Voucher. Store orders only with Card or Cash.

```excel
=SI(E2="Store"; ELEGIR(ALEATORIO.ENTRE(1;2);"Card";"Cash");
                ELEGIR(ALEATORIO.ENTRE(1;3);"PayPal";"Card";"Voucher"))
```

```excel
=IF(E2="Store", CHOOSE(RANDBETWEEN(1,2),"Card","Cash"),
                CHOOSE(RANDBETWEEN(1,3),"PayPal","Card","Voucher"))
```

## 4. Derived fields

- **Price per unit:** looked up from the Products table by `product_id`.
- **Total amount:** `quantity × price per unit`.
- **Week day:** day of the week from the transaction date.
- **Controlled NULLs:** blank values introduced on purpose to simulate a real data capture process.
