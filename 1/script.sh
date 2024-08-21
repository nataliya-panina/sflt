```
#!/bin/bash

nc -z localhost 80

if [ $? -eq 0 ]; then
        if [ -e /var/www/html/index.html ]; then exit 0;
else
exit 1;
fi
fi
```
