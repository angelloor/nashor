// // child_process: Módulo que nos permite generar subprocesos.
// // spawn: Método que genera un subproceso
// const spawn = require('child_process').spawn
// // spawn recibe el comando a ejecutar y los argumentos, es similar a utilizar desde línea de comandos "python script_python.py"
// const pythonProcess = spawn('python', ['python.py'])
// let pythonResponse = ""

// // stdout: Se encarga de la salida de datos del stdout del subproceso. En este caso, recibe datos del subproceso de Python.
// // .stdout.on('data',…): Ejecuta una función especificada cuando se reciben los datos que envía el subproceso.
// pythonProcess.stdout.on('data', function (data) {
//     pythonResponse += data.toString()
// })
// // .stdout.on('end',…): Ejecuta una función especificada cuando se terminan de recibir datos desde el subproceso.
// pythonProcess.stdout.on('end', function () {
//     console.log(pythonResponse)
// })

// // stdin: Se encarga del ingreso de datos al stdin del subproceso. En este caso, envía datos del subproceso de Python.
// // .stdin.write(datos): Envía datos al subproceso
// pythonProcess.stdin.write('backendi')
// // .stdin.end(): Indica al subproceso que el envío de datos finalizó para que pueda ejecutar sus acciones
// pythonProcess.stdin.end()


