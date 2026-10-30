# INC-011 — Estudiantes de Docencia matriculados en el curso de Administración

- INC-ID: INC-011
- Fecha / VM / paso: fecha exacta no registrada (antes de la prueba de aceptación del 2026-10-24) / VM cliente Linux Mint de una integrante → Moodle en `192.168.50.1:8080` / Paso 6.7 (matrícula por cohorte)
- Estado: resuelto (confirmado por la integrante); verificado por captura posterior del curso ([EV-087](../../docs/procedimientos/06-moodle/06-07/evidencias/EV-087.md))

## Síntoma y contexto

En una revisión de **Participantes** del curso «Gestión Documental y Procesos Administrativos» (`CTCR-ADM-101`) aparecieron **6 participantes** en lugar de 4. Además de Marta Jiménez, Carlos Méndez, Laura Rodríguez y el administrador, estaban **Sofía Hernández Vega y José Ramírez Salazar**, estudiantes de la cohorte de Docencia.

![EV-090](../../docs/procedimientos/06-moodle/06-07/evidencias/EV-090.webp)

Al intentar quitarlos, se marcaron sus casillas y luego se desmarcaron. Moodle mostró los avisos «Usuario 'Sofía Hernández Vega' eliminado de la selección» y «Usuario 'José Ramírez Salazar' eliminado de la selección», pero la lista seguía con 6 participantes.

![EV-091](../../docs/procedimientos/06-moodle/06-07/evidencias/EV-091.webp)

## Impacto, severidad y riesgo

- **Severidad:** alta para el objetivo del proyecto. Rompe el requisito RE-02: dos personas de Docencia podían abrir el curso, los recursos y el cuestionario de Administración.
- **Riesgo adicional:** dar por corregido el problema por los avisos «eliminado de la selección», cuando en realidad nadie fue dado de baja.

## Diagnóstico

1. «Eliminado de la selección» se refiere a las **casillas** de la tabla de Participantes, que sirven para aplicar acciones en grupo. Desmarcar una casilla no cambia la matrícula. Por eso el contador seguía en 6 (EV-091).
2. Sofía y José solo pertenecen a la cohorte `CTCR-COH-DOC`. Si estaban en el curso de Administración con rol Estudiante, la causa más probable es un método de matrícula de más en ese curso, por ejemplo una **sincronización de la cohorte «Personal de Docencia»** añadida por error al repetir el procedimiento en el curso equivocado.
3. No se conservó captura de la tabla de Métodos de matriculación con el método incorrecto, así que la causa exacta queda como **probable**, no observada.

## Solución y por qué

Ruta: curso de Administración → **Participantes → Métodos de matriculación**.

1. Revisar todas las filas de la tabla. Debe quedar **solo**:
   - Matriculación manual (para la profesora Laura).
   - Sincronizar cohorte (Personal de Administración - Estudiante).
   - Acceso de invitados y Auto-matriculación, desactivados.
2. Eliminar con la papelera cualquier otro método vinculado a Personal de Docencia (u otra cohorte ajena). Al borrar una sincronización de cohorte, Moodle da de baja a los usuarios que entraron por ella.
3. Si en cambio Sofía o José hubieran entrado por **matrícula manual**, se les da de baja desde la papelera de su fila en Participantes, no desmarcando casillas.

Se elige corregir el método y no a las personas porque la sincronización volvería a matricularlas mientras el método incorrecto exista.

## Verificación y recuperación

- La integrante confirmó haber eliminado el método incorrecto.
- La captura posterior del curso muestra **4 participantes**: Marta y Carlos (Estudiante), Laura (Profesor) y el administrador; Sofía y José ya no aparecen ([EV-087](../../docs/procedimientos/06-moodle/06-07/evidencias/EV-087.md)).
- La cohorte de Docencia sigue intacta y Sofía y José siguen en su propio curso ([EV-088](../../docs/procedimientos/06-moodle/06-07/evidencias/EV-088.md)).
- No se registró si Sofía o José llegaron a abrir recursos o intentar el cuestionario de Administración mientras estuvieron matriculados; si hubiera intentos, se borran con la baja.

## Prevención y documentación asociada

- El procedimiento [06-07](../../docs/procedimientos/06-moodle/06-07.md) ahora indica «una cohorte por curso», qué filas deben quedar en Métodos de matriculación y cómo dar de baja correctamente.
- Después de configurar cada curso, revisar Participantes y compararlo con la tabla de DATOS-MAESTROS antes de pasar al siguiente.
- La prueba de aislamiento de [06-08](../../docs/procedimientos/06-moodle/06-08.md) se hace con cuentas no privilegiadas y por URL directa, para detectar este tipo de error aunque no se revise la lista de participantes.
- Fuente: informe de implementación de los pasos 2 a 6, sección 8 y figuras 5 y 6.
