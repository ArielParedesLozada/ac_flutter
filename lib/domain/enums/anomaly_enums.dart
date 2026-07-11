// Tipos
enum AnomalyType {
  pdi, // PersonOfInterest
  al, // AnomalousLocation
  kte, // KnownThreatEntity
}

// Clases
// Tu sabes que significa esto
enum AnomalyClass {
  principalis, // 0
  thaumiel, // 1
  safe, // 2
  euclid, // 3
  keter, // 4
  apollyon, // 5
}

// Cuanta informacion se tiene
enum AnomalyInfo {
  caligo, // No information
  cernunnos, // basic information
  hiemal, // little information
  tiamat, // average information
  ticonderoga, // predictable behaviour
  archon, // fully known
}

// Esto para el poder
enum AnomalyDisruption {
  nikeri, // No power at all
  dark, // Not much power
  vlam,
  keneq,
  ekhi,
  amida, // Powerful
}

// Hostilidad
enum AnomalyHostility {
  ignore, // Not hostile
  notice,
  caution,
  warning,
  danger,
  critical, // Very hostile
}
