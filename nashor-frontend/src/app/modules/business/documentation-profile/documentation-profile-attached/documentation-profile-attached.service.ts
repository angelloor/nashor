import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { environment } from 'environments/environment';
import {
  BehaviorSubject,
  map,
  Observable,
  of,
  switchMap,
  take,
  tap,
  throwError,
} from 'rxjs';
import {
  documentationProfileAttached,
  documentationProfileAttacheds,
} from './documentation-profile-attached.data';
import { DocumentationProfileAttached } from './documentation-profile-attached.types';

@Injectable({
  providedIn: 'root',
})
export class DocumentationProfileAttachedService {
  private _url: string;
  private _headers: HttpHeaders = new HttpHeaders({
    'Content-Type': 'application/json',
  });

  private _documentationProfileAttached: BehaviorSubject<DocumentationProfileAttached> =
    new BehaviorSubject(documentationProfileAttached);
  private _documentationProfileAttacheds: BehaviorSubject<
    DocumentationProfileAttached[]
  > = new BehaviorSubject(documentationProfileAttacheds);

  constructor(private _httpClient: HttpClient) {
    this._url =
      environment.urlBackend + '/app/business/documentation_profile_attached';
  }
  /**
   * Getter
   */
  get documentationProfileAttached$(): Observable<DocumentationProfileAttached> {
    return this._documentationProfileAttached.asObservable();
  }
  /**
   * Getter for _documentationProfileAttacheds
   */
  get documentationProfileAttacheds$(): Observable<
    DocumentationProfileAttached[]
  > {
    return this._documentationProfileAttacheds.asObservable();
  }
  /**
   * create
   */
  create(id_user_: string, id_documentation_profile: string): Observable<any> {
    return this._documentationProfileAttacheds.pipe(
      take(1),
      switchMap((documentationProfileAttacheds) =>
        this._httpClient
          .post(
            this._url + '/create',
            {
              id_user_: parseInt(id_user_),
              documentation_profile: {
                id_documentation_profile: parseInt(id_documentation_profile),
              },
            },
            {
              headers: this._headers,
            }
          )
          .pipe(
            switchMap((response: any) => {
              /**
               * check the response body to match with the type
               */
              const _documentationProfileAttached: DocumentationProfileAttached =
                response.body;
              /**
               * Update the documentationProfileAttached in the store
               */
              this._documentationProfileAttacheds.next([
                ...documentationProfileAttacheds,
                _documentationProfileAttached,
              ]);

              return of(_documentationProfileAttached);
            })
          )
      )
    );
  }
  /**
   * byDocumentationProfileRead
   * @param id_documentation_profile
   */
  byDocumentationProfileRead(
    id_documentation_profile: string
  ): Observable<DocumentationProfileAttached[]> {
    return this._httpClient
      .get<DocumentationProfileAttached[]>(
        this._url + `/byDocumentationProfileRead/${id_documentation_profile}`
      )
      .pipe(
        tap((documentationProfileAttacheds: DocumentationProfileAttached[]) => {
          if (documentationProfileAttacheds) {
            this._documentationProfileAttacheds.next(
              documentationProfileAttacheds
            );
          } else {
            this._documentationProfileAttacheds.next([]);
          }
        })
      );
  }
  /**
   * byAttachedRead
   * @param id_attached
   */
  byAttachedRead(
    id_attached: string
  ): Observable<DocumentationProfileAttached[]> {
    return this._httpClient
      .get<DocumentationProfileAttached[]>(
        this._url + `/byAttachedRead/${id_attached}`
      )
      .pipe(
        tap((documentationProfileAttacheds: DocumentationProfileAttached[]) => {
          if (documentationProfileAttacheds) {
            this._documentationProfileAttacheds.next(
              documentationProfileAttacheds
            );
          } else {
            this._documentationProfileAttacheds.next([]);
          }
        })
      );
  }
  /**
   * specificRead
   * @param id_documentationProfileAttached
   */
  specificRead(
    id_documentationProfileAttached: string
  ): Observable<DocumentationProfileAttached> {
    return this._httpClient
      .get<DocumentationProfileAttached>(
        this._url + `/specificRead/${id_documentationProfileAttached}`
      )
      .pipe(
        tap((documentationProfileAttached: DocumentationProfileAttached) => {
          this._documentationProfileAttached.next(documentationProfileAttached);
          return documentationProfileAttacheds;
        })
      );
  }
  /**
   * specificReadInLocal
   */
  specificReadInLocal(
    id_documentationProfileAttached: string
  ): Observable<DocumentationProfileAttached> {
    return this._documentationProfileAttacheds.pipe(
      take(1),
      map((documentationProfileAttacheds) => {
        /**
         * Find
         */
        const documentationProfileAttached =
          documentationProfileAttacheds.find(
            (item) =>
              item.id_documentation_profile_attached ==
              id_documentationProfileAttached
          ) || null;
        /**
         * Update
         */
        this._documentationProfileAttached.next(documentationProfileAttached!);
        /**
         * Return
         */
        return documentationProfileAttached;
      }),
      switchMap((documentationProfileAttached) => {
        if (!documentationProfileAttached) {
          return throwError(
            () =>
              'No se encontro el elemento con el id ' +
              id_documentationProfileAttached +
              '!'
          );
        }
        return of(documentationProfileAttached);
      })
    );
  }
  /**
   * update
   * @param documentationProfileAttached
   */
  update(
    documentationProfileAttached: DocumentationProfileAttached
  ): Observable<any> {
    return this.documentationProfileAttacheds$.pipe(
      take(1),
      switchMap((documentationProfileAttacheds) =>
        this._httpClient
          .patch(this._url + '/update', documentationProfileAttached, {
            headers: this._headers,
          })
          .pipe(
            switchMap((response: any) => {
              /**
               * check the response body to match with the type
               */
              const _documentationProfileAttached: DocumentationProfileAttached =
                response.body;
              /**
               * Find the index of the updated documentationProfileAttached
               */
              const index = documentationProfileAttacheds.findIndex(
                (item) =>
                  item.id_documentation_profile_attached ==
                  documentationProfileAttached.id_documentation_profile_attached
              );
              /**
               * Update the documentationProfileAttached
               */
              documentationProfileAttacheds[index] =
                _documentationProfileAttached;
              /**
               * Update the documentationProfileAttacheds
               */
              this._documentationProfileAttacheds.next(
                documentationProfileAttacheds
              );

              /**
               * Update the documentationProfileAttached
               */
              this._documentationProfileAttached.next(
                _documentationProfileAttached
              );

              return of(_documentationProfileAttached);
            })
          )
      )
    );
  }
  /**
   * delete
   * @param id_user_
   * @param id_documentation_profile_attached
   */
  delete(
    id_user_: string,
    id_documentation_profile_attached: string
  ): Observable<any> {
    return this.documentationProfileAttacheds$.pipe(
      take(1),
      switchMap((documentationProfileAttacheds) =>
        this._httpClient
          .delete(this._url + `/delete`, {
            params: { id_user_, id_documentation_profile_attached },
          })
          .pipe(
            switchMap((response: any) => {
              if (response && response.body) {
                /**
                 * Find the index of the updated documentationProfileAttached
                 */
                const index = documentationProfileAttacheds.findIndex(
                  (item) =>
                    item.id_documentation_profile_attached ==
                    id_documentation_profile_attached
                );
                /**
                 * Delete the object of array
                 */
                documentationProfileAttacheds.splice(index, 1);
                /**
                 * Update the documentationProfileAttacheds
                 */
                this._documentationProfileAttacheds.next(
                  documentationProfileAttacheds
                );
                return of(response.body);
              } else {
                return of(false);
              }
            })
          )
      )
    );
  }
}
