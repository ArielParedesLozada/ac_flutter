// Tipos
enum AnomalyType {
  pdI, // PersonOfInterest
  al, // AnomalousLocation
  kte, // KnownThreatEntity
}

// Clases
// Tu sabes que significa esto
enum AnomalyClass {
  safe, // 1
  euclid, // 2
  keter,
  thaumiel,
  apollyon, // 5
}

// Cuanta informacion se tiene
enum AnomalyInfo {
  cernunnos, // No information
  hiemal, // little information
  tiamat, // average information
  ticonderoga, // predictable behaviour
  archon, // fully known
}

// Esto para el poder
enum AnomalyDisruption {
  dark, // Not much power
  vlam,
  keneq,
  ekhi,
  amida, // Powerful
}

// Hostilidad
enum AnomalyHostility {
  notice, // Not hostile
  caution,
  warning,
  danger,
  critical, // Very hostile
}
