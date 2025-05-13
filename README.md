# Proyecto 1 Diseño Logico

## 1. Abreviaturas y definiciones
- **FPGA**: Field Programmable Gate Arrays
- **Sumador**: Circuito digital que suma 2 numeros
- **Flip Flop**: Circuitos que permite almancenar un valor binario
- **Debounce**: Un debounce (o antirrebote) es una técnica usada en electrónica digital para eliminar señales erróneas causadas por el rebote mecánico de botones o interruptores.

## 2. Descripción general del sistema
<img src="Recursos/ALL.png" alt="Diagrama Completo" width="700">

<div style="text-align: justify"> Este circuito de manera general se encarga de recibir 2 numeros por medio de un teclado hexadecimal, los cuales son almacenados de manera interna por medio de flip flops, los cuales se encuentran controlados por una maquina de estados. Los numeros pasan por un debouncer, el cual permite limpiar toda la señal de entrada de manera que solo se reciba el numero. Una vez que la señal se filtro, se lleva directamente al modulo de la maquina de estados que suma. La maquina de estados se encarga de que al recibir la señal de una tecla presionada, este valor sea guardado en un los digitos de cada uno de los numeros a sumar, la primera tecla son las centenas, la segunda las decenas y la ultima llena las unidades. Una vez que se tienen los 2 numeros, estos se suman, la suma tambien es guardada por medio de un flip flop en la maquina de estados. Por ultimo, este numero se despligueda por medio de un mux que le indica a cada display que despleguar y un display decoder, que transfiere el numero a su respectivo codigo en 7 segment display. </div>
 

### **2.1 Módulo `DeBounce`**
#### 1. Funcionamiento
<div style="text-align: justify"> El codificador de Hamming se encarga de recibir el mensaje codificado enviado desde los Dip Switches y lograr realizar una decodificación de Hamming al obtener los síndromes necesarios para lograr posicionar el error presente en este. Para esto se realiza la decodificación con los bits de paridad y se asignan a p[2:0] dejando el cuarto bit siempre en 0. Por último, este mismo modulo se encarga de lanzar los valores del número correcto hacia las leds de la FPGA, permitiendo desplegar el numero correcto ahi. </div>

#### 2. Encabezado del módulo
```SystemVerilog
module DeBounce(----); // Sindrome
```
#### 3. Parámetros
```SystemVerilog
----
```


#### 4. Criterios de diseño
<img src="Recursos/DB.png" alt="DB" width="500">


#### 5. Testbench
-----


### **2.2 Módulo `disp_controller`**
#### 1. Funcionamiento
<div style="text-align: justify"> El módulo disp_controller se encarga de dividir la frecuencia ademas de enlazar esto con un One Hot, el cual sera transmitido hacia el mux para poder decirle a cada display cual de los valores representar y ademas cuando tienen que activarse. Esto seria la variable "a". </div>

#### 2. Encabezado del módulo
```SystemVerilog
module mux(
    input logic clk,
    output logic [3:0] a
);

```
#### 3. Parámetros
```SystemVerilog
    always_ff @(posedge clk) begin
        if (count == max_count - 1) begin
            // Cambia el estado de los segmentos en secuencia cíclica
            case (a)
                4'b0001: a <= 4'b0010;
                4'b0010: a <= 4'b0100;
                4'b0100: a <= 4'b1000;
                4'b1000: a <= 4'b0001;
                default: a <= 4'b1000;
            endcase
            count <= 0;
        end 
        else begin
            count <= count + 1;
        end
    end
```


#### 4. Criterios de diseño
![Display Controller](Recursos/DC.png)


#### 5. Testbench


### **2.3 Módulo `disp_dec`**
#### 1. Funcionamiento
<div style="text-align: justify">El display decoder se encarga de recibir la señal del modulo sume, el cual basicamente da el resultado de la suma de los 2 digitos. Por medio de la variable cdu, el cual es un numero de 4 digitos (16 bits) se dividen los digitos por medio del mux, dando como resultado w. Esta variable es trabajada como un hot one, que activa uno de los digitos especificamente, el cual se ve reflejado por el d.</div>

#### 2. Encabezado del módulo
```SystemVerilog
module disp_dec(
    input logic [3:0] w, 
    output logic [6:0] d
);

```
#### 3. Parámetros
```SystemVerilog
-----
```


#### 4. Criterios de diseño
![Coder del Display](Recursos/DD.png)


#### 5. Testbench
----


### **2.4 Módulo `lecture`**
#### 1. Funcionamiento
<div style="text-align: justify">Este modulo se encarga de recibir los inputs directamente del circuito, estas siendo los variables llamadas raw. Una vez que se reciben estas señales estas son inicializadas por medio de 4 instancias del DeBounce, el cual logra filtrar por completo la señal, dando como resultado solamente el valor de la señal del numero presionado. Una vez que esto pasa, la salida se pasa por un tipo de decoder, retornando por medio de sample, el numero presionado.</div>


#### 2. Encabezado del módulo
```SystemVerilog
module lecture (
    input logic clk,
    input logic n_reset,
    input logic [3:0] filas_raw,        // Entradas directas desde las filas del teclado
    output logic [3:0] columnas,
    output logic [3:0] sample           // Salidas debouneada
);      
```
#### 3. Parámetros
```SystemVerilog
-----
```


#### 4. Criterios de diseño
![Lecture](Recursos/LE.png)


#### 5. Testbench


### **2.5 Módulo `mux`**

#### 1. Funcionamiento
<div style="text-align: justify">El mux especificamente se encarga de recibir el uno de los valores del One Hot (a), para de esta manera, mandar la señal correcta del display. Esto se envia por medio de la variable w, la cual extrae el digito correcto del numero de cdu. </div>

#### 2. Encabezado del módulo
```SystemVerilog
module mux(
    input logic [2:0] a,    // Maquina de estados one-hot
    input logic [15:0] cdu,    // cdu[3:0] = unidades, cdu[7:4] = decenas, cdu[11:8] = centenas
    output logic [3:0] w    // Numero de 4 bits (salida)
);
```
#### 3. Parámetros
```SystemVerilog
    assign w = (a == 4'b0001) ? cdu[3:0] :  // unidades
               (a == 4'b0010) ? cdu[7:4] :  // decenas 
               (a == 4'b0100) ? cdu[11:8] : // centenas
               (a == 4'b1000) ? cdu[15:12] : // Millares
               4'b0000;
```


#### 4. Criterios de diseño
<img src="Recursos/MUX.png" alt="MUX" width="100">


#### 5. Testbench
-----




### **2.6 Módulo `sume`**
#### 1. Funcionamiento
<div style="text-align: justify">.</div>

#### 2. Encabezado del módulo
```SystemVerilog
module mux(----); // Sindrome
```
#### 3. Parámetros
```SystemVerilog
----
```


#### 4. Criterios de diseño
<img src="Recursos/SUME.png" alt="DB" width="500">


#### 5. Testbench
-----

### **2.7 Módulo `top`**
#### 1. Funcionamiento
<div style="text-align: justify">Este modulo se encarga de conectar el resto, por medio de las variables iniciales que son usadas en el primer modulo, ademas de los outputs que se tienen que sacar en al final. Ademas, en este modulo se instancia el resto, designando cuales variables reciben, las conexiones de los cables y definir las salidas. </div>

#### 2. Encabezado del módulo
```SystemVerilog
module top(
    input logic clk,
    input logic [3:0] filas_raw, // Entradas directas desde las filas del teclado
    output logic [6:0] d,  // Segmentos
    output logic [3:0] a, // Control de los segmentos
    output logic [3:0] columnas, // Salida de la FSM de columnas 
    output logic [3:0] led  // Senal de debug
    );       // Sindrome
```
#### 3. Parámetros
```SystemVerilog
    disp_dec decoder (.w(w), .d(d));
    disp_controller controller (.clk(clk), .a(a));
    mux mux (.a(a), .cdu(cdu), .w(w));
 
    sume suma (
    .clk(clk),              
    .sample(sample),       
    .cdu(cdu),
    .debug(led)              
    );

    lecture lect (
        .clk(clk),
        .n_reset(n_reset),
        .filas_raw(filas_raw),
        .columnas(columnas),
        .sample(sample)
    );

```


#### 4. Criterios de diseño
<img src="Recursos/TP.png" alt="TOP" width="500">


## 4. Problemas encontrados durante el proyecto
Durante la realización del proyecto se encontraron varios problemas:
1.  Poca familiaridad con el lenguaje de Verilog y su sintaxis
- R/ Uso de recursos en línea como videos tutoriales, paginas web, datasheets y manuales de la FPGA. 

2. Falta de disponibilidad de ambos estudiantes para lograr reunirse
- R/ Mas coordinación y comunicación además de lograr subir el nivel de prioridad del proyecto. 

3.  Poca familiaridad con el dispositivo Tang Nano 9k
- R/ Uso de tanto manuales como tutoriales para lograr entender su funcionamiento adecuado. 

4.  Incapacidad de las instrucciones del proyecto para presentar ciertas ideas o direcciones
- R/ Aclaración de estas dudas tanto con el profesor como el asistente del curso para lograr implementar todas las ideas. 

5.  Fallos desconocidos tanto en la parte física como en la implementación del código.
- R/ Realizar troubleshooting en la parte de programación por medio de los test benchs como en la parte física por medio de herramientas de laboratorio. 



### 5. Resultados y Análisis
- Obtención de formas de onda con el osciloscopio.
- Cálculo del tiempo de propagación promedio del inversor.
- Comparación de resultados entre diferentes configuraciones del oscilador.

## Apendices:


## 1. Referencias
[0] OpenAI. (2025). ChatGPT conversation about debounce. Retrieved from [https://chatgpt.com/c/68237c47-c858-8005-937f-59e6cbdb20d2]