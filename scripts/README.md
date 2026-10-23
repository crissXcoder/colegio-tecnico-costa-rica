# Scripts utilitarios

- `generate-env.sh`: inicializa claves en `.env` local sin mostrarlas ni sobreescribir existentes.
- `inventory.sh`: recoge versiones y estado no destructivo; verificar antes de compartir salida.
- `backup-db.sh`: ejemplo de dump MariaDB vía Compose con temporales, permisos y retención. **Primero probar en VM y restaurar sobre DB de ensayo.**
- `validate-repository.py`: comprueba estructura documental y ausencia de ciertos errores obvios; no sustituye tests de servicios.

**No hay script de «instalar todo» a propósito**: BIND9, puertos, firewall, LVM, Moodle y FTPS requieren inspección contextual. Automatizarlos ciegamente arriesga los laboratorios anteriores.
