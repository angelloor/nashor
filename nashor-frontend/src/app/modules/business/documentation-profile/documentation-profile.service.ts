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
  throwError
} from 'rxjs';
import {
  documentationProfile,
  documentationProfiles
} from './documentation-profile.data';
import { DocumentationProfile } from './documentation-profile.types';

@Injectable({
  providedIn: 'root',
})
export class DocumentationProfileService {
  private _url: string;
  private _headers: HttpHeaders = new HttpHeaders({
    'Content-Type': 'application/json',
  });

  private _documentationProfile: BehaviorSubject<DocumentationProfile> =
    new BehaviorSubject(documentationProfile);
  private _documentationProfiles: BehaviorSubject<DocumentationProfile[]> =
    new BehaviorSubject(documentationProfiles);

  constructor(private _httpClient: HttpClient) {
    this._url = environment.urlBackend + '/app/business/documentation_profile';
  }
  /**
   * Getter
   */
  get documentationProfile$(): Observable<DocumentationProfile> {
    return this._documentationProfile.asObservable();
  }
  /**
   * Getter for _documentationProfiles
   */
  get documentationProfiles$(): Observable<DocumentationProfile[]> {
    return this._documentationProfiles.asObservable();
  }
  /**
   * create
   */
  create(id_user_: string, id_company: string): Observable<any> {
    return this._documentationProfiles.pipe(
      take(1),
      switchMap((documentationProfiles) =>
        this._httpClient
          .post(
            this._url + '/create',
            {
              id_user_: parseInt(id_user_),
              company: {
                id_company: parseInt(id_company),
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
              const _documentationProfile: DocumentationProfile = response.body;
              console.log(_documentationProfile);
              /**
               * Update the documentationProfile in the store
               */
              this._documentationProfiles.next([
                _documentationProfile,
                ...documentationProfiles,
              ]);

              return of(_documentationProfile);
            })
          )
      )
    );
  }
  /**
   * queryRead
   * @param query
   */
  queryRead(query: string): Observable<DocumentationProfile[]> {
    return this._httpClient
      .get<DocumentationProfile[]>(
        this._url + `/queryRead/${query ? query : '*'}`
      )
      .pipe(
        tap((documentationProfiles: DocumentationProfile[]) => {
          if (documentationProfiles) {
            this._documentationProfiles.next(documentationProfiles);
          } else {
            this._documentationProfiles.next([]);
          }
        })
      );
  }
  /**
   * byCompanyQueryRead
   * @param id_company
   * @param query
   */
  byCompanyQueryRead(
    id_company: string,
    query: string
  ): Observable<DocumentationProfile[]> {
    return this._httpClient
      .get<DocumentationProfile[]>(
        this._url + `/byCompanyQueryRead/${id_company}/${query ? query : '*'}`
      )
      .pipe(
        tap((documentationProfiles: DocumentationProfile[]) => {
          if (documentationProfiles) {
            this._documentationProfiles.next(documentationProfiles);
          } else {
            this._documentationProfiles.next([]);
          }
        })
      );
  }
  /**
   * specificRead
   * @param id_documentationProfile
   */
  specificRead(
    id_documentationProfile: string
  ): Observable<DocumentationProfile> {
    return this._httpClient
      .get<DocumentationProfile>(
        this._url + `/specificRead/${id_documentationProfile}`
      )
      .pipe(
        tap((documentationProfile: DocumentationProfile) => {
          this._documentationProfile.next(documentationProfile);
          return documentationProfiles;
        })
      );
  }
  /**
   * specificReadInLocal
   */
  specificReadInLocal(
    id_documentationProfile: string
  ): Observable<DocumentationProfile> {
    return this._documentationProfiles.pipe(
      take(1),
      map((documentationProfiles) => {
        /**
         * Find
         */
        const documentationProfile =
          documentationProfiles.find(
            (item) => item.id_documentation_profile == id_documentationProfile
          ) || null;
        /**
         * Update
         */
        this._documentationProfile.next(documentationProfile!);
        /**
         * Return
         */
        return documentationProfile;
      }),
      switchMap((documentationProfile) => {
        if (!documentationProfile) {
          return throwError(
            () =>
              'No se encontro el elemento con el id ' +
              id_documentationProfile +
              '!'
          );
        }
        return of(documentationProfile);
      })
    );
  }
  /**
   * update
   * @param documentationProfile
   */
  update(documentationProfile: DocumentationProfile): Observable<any> {
    return this.documentationProfiles$.pipe(
      take(1),
      switchMap((documentationProfiles) =>
        this._httpClient
          .patch(this._url + '/update', documentationProfile, {
            headers: this._headers,
          })
          .pipe(
            switchMap((response: any) => {
              /**
               * check the response body to match with the type
               */
              const _documentationProfile: DocumentationProfile = response.body;
              console.log(_documentationProfile);
              /**
               * Find the index of the updated documentationProfile
               */
              const index = documentationProfiles.findIndex(
                (item) =>
                  item.id_documentation_profile ==
                  documentationProfile.id_documentation_profile
              );
              console.log(index);
              /**
               * Update the documentationProfile
               */
              documentationProfiles[index] = _documentationProfile;
              /**
               * Update the documentationProfiles
               */
              this._documentationProfiles.next(documentationProfiles);

              /**
               * Update the documentationProfile
               */
              this._documentationProfile.next(_documentationProfile);

              return of(_documentationProfile);
            })
          )
      )
    );
  }
  /**
   * delete
   * @param id_user_
   * @param id_documentation_profile
   */
  delete(id_user_: string, id_documentation_profile: string): Observable<any> {
    return this.documentationProfiles$.pipe(
      take(1),
      switchMap((documentationProfiles) =>
        this._httpClient
          .delete(this._url + `/delete`, {
            params: { id_user_, id_documentation_profile },
          })
          .pipe(
            switchMap((response: any) => {
              if (response && response.body) {
                /**
                 * Find the index of the updated documentationProfile
                 */
                const index = documentationProfiles.findIndex(
                  (item) =>
                    item.id_documentation_profile == id_documentation_profile
                );
                console.log(index);
                /**
                 * Delete the object of array
                 */
                documentationProfiles.splice(index, 1);
                /**
                 * Update the documentationProfiles
                 */
                this._documentationProfiles.next(documentationProfiles);
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
