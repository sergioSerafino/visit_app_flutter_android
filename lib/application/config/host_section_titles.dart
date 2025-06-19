// Zentrale Map für mandantenspezifische Section-Titel
const hostSectionTitles = {
  // Beispiel: collectionId 1
  1: {
    'about': 'Bio / Mission / Persona',
    'contact': 'Anfahrt / Visit / Kontakt',
    'portfolio': 'Angebote / Entdecken',
  },
  // Weitere Mandanten können hier ergänzt werden
};

String getSectionTitle(int collectionId, String sectionKey, String fallback) {
  return hostSectionTitles[collectionId]?[sectionKey] ?? fallback;
}

/// TODO: Die gesamte App sollte vor Veröffentlichung daraufhin untersucht werden, ob alle Abschnittsüberschriften (z. B. in HostSectionHeader) mandantenspezifisch aus dem jeweiligen host_model.json (Feld "sectionTitles") geladen werden.
/// Vorteil: Überschriften sind versionierbar, flexibel und ohne Code-Änderung anpassbar. Die bisherige zentrale Map kann dann entfallen.
