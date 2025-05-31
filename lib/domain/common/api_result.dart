// ...original code from storage_hold/lib/domain/common/api_result.dart...
// lib/domain/common/api_result.dart

/*
Der Result<T>-Ansatz ist perfekt, wenn du…

    ... entkoppelt von Flutter oder UI-States mit Logik, UseCases oder Domain-Prozessen arbeitest –
    also kein loading/success/error wie bei ApiResponse<T>,
    sondern:

| Ergebnisform | Bedeutung
|--------------|---------------------------------------------------------------------------|
| Success<T>   | Toller Rückgabewert                                                       |
| Failure<E>   | Ein Fehlerobjekt mit Kontext                                              |
| Result<T>    | Gemeinsam super für z. B. UseCases, Validierungen, Async-Operationen etc. |

| Zweck                                   | ApiResponse<T>                      | Result<T>                  |
|-----------------------------------------|----------------------------------   |----------------------------|
| UI-Kompatibel (Riverpod, State, Async)  | ✅                                  | ❌ (eher logisch)         |
| Datenfluss in der App / API             | ✅                                  | ✅                        |
| Ideal für UseCases, Prüfungen           | ⚠️                                  | ✅
| Entkoppelt von Flutter                  | ⚠️ (Freezed benötigt Flutter SDK)   | ✅ (reines Dart)
| Im UI nutzbar                           | ✅                                  | eher über Wrapper/Funktion
| Serialisierbar                          | ✅                                  | nur mit Zusatzarbeit


🔄 Empfehlung: Kombinieren und beide nutzen
| Schicht            | Typ                                      |
|--------------------|------------------------------------------|
| UI / Riverpod      | ApiResponse<T> (mit Loading usw.)        |
| UseCases / Domain  | Result<T> (ohne UI-Kopplung)             |
| Service / Parser   | Result<T> oder Exceptions                |
| FallbackLogik      | Result<T> mit FeatureFlag/Reason etc.    |

✅ Vorteile:
  + leicht testbar (kein Framework nötig)
  + leicht loggbar
  + in Jeder Schicht einsetzbar: Domain, UseCase, MergeService, RegistryLoader, etc.
  + auch nutzbar für: Auth-Resultate, Episode-Validierung, RSS-Parsing, etc.

Gut für z.B. einen FetchPodcastCollectionUseCase
Oder z.B. im Repository Result<T> → ApiResponse<T> mappen

*/

// lib/domain/common/result.dart

abstract class Result<T> {
  const Result();
}

class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

class Failure<T> extends Result<T> {
  final String message;
  final dynamic error; // z. B. Exception, StackTrace oder ValidationInfo

  const Failure(this.message, {this.error});
}

extension ResultX<T> on Result<T> {
  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Failure<T>;

  T? get data => this is Success<T> ? (this as Success<T>).data : null;
  String? get errorMessage =>
      this is Failure<T> ? (this as Failure<T>).message : null;

  R when<R>({
    required R Function(T data) success,
    required R Function(String msg, dynamic error) failure,
  }) {
    if (this is Success<T>) {
      return success((this as Success<T>).data);
    } else if (this is Failure<T>) {
      return failure((this as Failure<T>).message, (this as Failure<T>).error);
    }
    throw StateError('Unhandled Result state');
  }
}

/*
// Anwendung in UseCase / Service

Result<PodcastCollection> result = await fetchPodcastCollection();

result.when(
  success: (collection) => print("Podcasts: ${collection.podcasts.length}"),
  failure: (msg, err) => print("Fehler: $msg"),
);

*/
