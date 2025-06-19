class Nave {
    var velocidad
    var dirRespectoAlSol
    var combustible
    method acelerar(unNumero) {velocidad += unNumero.min(100000)}
    method desacelerar(unNumero) {velocidad -= unNumero.max(0)}
    method irHaciaElSol() {dirRespectoAlSol = 10}
    method escaparDelSol() {dirRespectoAlSol = -10}
    method ponerseParaleloAlSol() {dirRespectoAlSol = 0}
    method acercarseUnPocoAlSol() {dirRespectoAlSol += 1.min(10)}
    method alejarseUnPocoDelSol() {dirRespectoAlSol -= 1.max(0)}
    method cargarCombustible(unaCantidad) {combustible += unaCantidad}
    method descargarCombustible(unaCantidad) {combustible -= unaCantidad}
    method prepararViaje() {
        self.cargarCombustible(30000)
        self.acelerar(5000)
        }
    method estaTranquila() = combustible > 4000 and velocidad <= 12000
    method recibirAmenaza()
    method estaDeRelajo() = self.estaTranquila()     
}

class NaveBaliza inherits Nave{
    var baliza
    var colorSinCambiar = true
    method cambiarColorDeBaliza(colorNuevo) {
        baliza = colorNuevo
        colorSinCambiar = false
        }
    override method prepararViaje() {
        super()
        self.cambiarColorDeBaliza("verde")
        self.ponerseParaleloAlSol()
        }
    override method estaTranquila() = super() and baliza != "rojo"
    override method recibirAmenaza() {
        self.irHaciaElSol()
        self.cambiarColorDeBaliza("rojo")
        }
    override method estaDeRelajo() = super() and colorSinCambiar               
}    
class NaveDePasajeros inherits Nave{
    var cantidadDePasajeros
    var cantidadDeComida
    var cantidadDeBebida
    var comidaServida = 0
    method cargarComida(cantidad) {cantidadDeComida += cantidad}
    method descargarComida(cantidad) {
        cantidadDeComida -= cantidad.max(0)
        comidaServida += cantidad
        }
    method cargarBebida(cantidad) {cantidadDeBebida += cantidad}
    method descargarBebida(cantidad) {cantidadDeBebida += cantidad.max(0)}
    override method prepararViaje() {
        super() 
        self.cargarComida(4 * cantidadDePasajeros) 
        self.cargarBebida(6 * cantidadDePasajeros) 
        self.acercarseUnPocoAlSol()
        }
    override method recibirAmenaza() {
        self.acelerar(velocidad) 
        self.descargarComida(cantidadDePasajeros)
        self.descargarBebida(cantidadDePasajeros * 2)
    }
    override method estaDeRelajo() = super() and comidaServida < 50           
}

class NaveDeCombate inherits Nave{
    var esVisible
    var misilesDesplegados
    const mensajesEmitidos = []
    method ponerseVisible() {esVisible = true}
    method ponerseInvisible() {esVisible = false}
    method estaInvisible() = not esVisible 
    method desplegarMisiles() {misilesDesplegados = true}
    method replegarMisiles() {misilesDesplegados = false}
    method misilesDesplegados() = misilesDesplegados
    method emitirMensaje(unMensaje) {mensajesEmitidos.add(unMensaje)}
    method mensajesEmitidos() = mensajesEmitidos
    method primerMensajeEmitido() = mensajesEmitidos.first()
    method ultimoMensajeEmitido() = mensajesEmitidos.last()
    method emitioMensaje(unMensaje) = mensajesEmitidos.contains(unMensaje)
    method esEscueta() = mensajesEmitidos.all({m => not m.length() > 30 })
    override method prepararViaje() {
        super()
        self.ponerseVisible()
        self.replegarMisiles()
        self.acelerar(15000)
        self.emitirMensaje("Saliendo en Mision")
    }
    override method estaTranquila() = super() and not misilesDesplegados
    override method recibirAmenaza() {
        self.acercarseUnPocoAlSol()
        self.acercarseUnPocoAlSol()
        self.emitirMensaje("Amenaza recibida")
    }
}

class NaveHospital inherits NaveDePasajeros{
    var quirofanosPreparados
    method prepararQuirofano() {quirofanosPreparados = true}
    method desmontarQuirofano() {quirofanosPreparados = false}
    method quirofanosPreparados() = quirofanosPreparados
    override method estaTranquila() = super() and not quirofanosPreparados
    override method recibirAmenaza() {
        super()
        self.prepararQuirofano()
    }
}



class NaveDeCombateSigilosa inherits NaveDeCombate{
    override method estaTranquila() = super() and esVisible
    override method recibirAmenaza() {
        super()
        self.desplegarMisiles()
        self.ponerseInvisible()
    }
}