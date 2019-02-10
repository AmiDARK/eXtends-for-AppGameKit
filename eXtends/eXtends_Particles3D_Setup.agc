// **************************************************************************** Définition des variables du système de particules
Global P3DInitialized AS INTEGER = 1
//
Global FLAMEPARTICLES AS STRING = "Flame.png"    // 262 156
Global SNOWPARTICLES AS STRING = "snow.png"      //   4.108
Global RAINPARTICLES AS STRING = "rain.png"      //  16.396
Global SPARKLEPARTICLES AS STRING = "sparkle.png" // 262.156
//
TYPE Particle_Structure
	mType AS INTEGER
	Count AS INTEGER
	Exist AS INTEGER
	Size AS INTEGER
	XEmitter AS FLOAT
	YEmitter AS FLOAT
	ZEmitter AS FLOAT
	XSize AS FLOAT
	YSize AS FLOAT
	ZSize AS FLOAT
	XMove AS FLOAT
	YMove AS FLOAT
	ZMove AS FLOAT
	XMin AS FLOAT
	YMin AS FLOAT
	ZMin AS FLOAT
	XMax AS FLOAT
	YMax AS FLOAT
	ZMax AS FLOAT
	Duration AS FLOAT
	Hide AS INTEGER
	LoadedImage AS INTEGER
	UseInternal AS INTEGER
ENDTYPE
Global Dim ParticleSystem[ 256 ] AS Particle_Structure
//
TYPE ParticleObject_Structure
	Number AS INTEGER
	XPos AS FLOAT
	YPos AS FLOAT
	ZPos AS FLOAT
	Duration AS Float
ENDTYPE
Global Dim ParticleObject[ 256, 512 ] AS ParticleObject_Structure
//
Global NextFlame AS INTEGER
Global NextSmoke AS INTEGER

