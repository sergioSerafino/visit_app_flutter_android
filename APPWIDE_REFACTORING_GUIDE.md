# Appweiter Refactoring-Guide

## Ziele
- **Vermeidung von God Classes**: Keine Klasse/Widget/Service darf mehr als eine klar abgegrenzte Verantwortung haben (Single Responsibility Principle).
- **Modularisierung**: Gemeinsame Logik wird in dedizierte Utilities/Services ausgelagert.
- **Nachhaltige Wartbarkeit, Testbarkeit und Erweiterbarkeit**.

## Best Practices
- **Strikte Trennung** von UI, Logik und Datenzugriff (siehe [Clean Architecture](.instructions/architecture_clean_architecture.md)).
- **Atomic Refactoring**: Kleine, nachvollziehbare, reversible Schritte.
- **Dokumentationspflicht**: Jede Refactoring-Maßnahme wird dokumentiert und mit Querverweis versehen.
- **Utility-Bibliothek**: Wiederverwendbare Funktionen werden zentral gepflegt.
- **Regelmäßige Reviews**: Fokus auf Klassengröße, Verantwortlichkeiten, Komplexität.

## Vorgehen & Checkliste
1. **Identifikation von God Classes**
   - Tools, Code-Reviews, Metriken (z.B. zyklomatische Komplexität, Klassengröße).
2. **Aufteilen in kleinere Einheiten**
   - Schrittweises Extrahieren von Verantwortlichkeiten in neue Klassen/Widgets/Services.
3. **Dokumentation**
   - Jede Änderung mit Querverweis auf dieses Dokument und relevante How-Tos.
4. **Doku-Matrix pflegen**
   - Eintrag/Update in [.instructions/doku_matrix.md](.instructions/doku_matrix.md).
5. **Automatisierte Checks**
   - Linter, statische Analyse, ggf. eigene Regeln.

## Querverweise
- [Clean Architecture Guide](.instructions/architecture_clean_architecture.md)
- [Projektstruktur & Best Practices](.instructions/project_structure_best_practices.md)
- [Refactoring How-To](REFACORING_HOWTO.md)
- [Doku-Matrix](.instructions/doku_matrix.md)
- [Utility- und Service-Übersicht](README.md, ggf. eigene Utility-README)
- [ADR-Übersicht](.instructions/adr-001-merge-strategy.md, .instructions/adr-002-cast-architektur.md)

---

**Hinweis:** Dieses Dokument ist verbindlich für alle Refactoring-Maßnahmen und wird bei jedem Refactoring aktualisiert. Änderungen müssen in der Doku-Matrix eingetragen werden.
