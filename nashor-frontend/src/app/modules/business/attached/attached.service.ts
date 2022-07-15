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
import { attached, attacheds } from './attached.data';
import { Attached } from './attached.types';

@Injectable({
  providedIn: 'root',
})
export class AttachedService {
  private _url: string;
  private _headers: HttpHeaders = new HttpHeaders({
    'Content-Type': 'application/json',
  });

  private _attached: BehaviorSubject<Attached> = new BehaviorSubject(attached);
  private _attacheds: BehaviorSubject<Attached[]> = new BehaviorSubject(
    attacheds
  );

  constructor(private _httpClient: HttpClient) {
    this._url = environment.urlBackend + '/app/business/attached';
  }
  /**
   * Getter
   */
  get attached$(): Observable<Attached> {
    return this._attached.asObservable();
  }
  /**
   * Getter for _attacheds
   */
  get attacheds$(): Observable<Attached[]> {
    return this._attacheds.asObservable();
  }
  /**
   * create
   */
  create(id_user_: string, id_company: string): Observable<any> {
    return this._attacheds.pipe(
      take(1),
      switchMap((attacheds) =>
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
              const _attached: Attached = response.body;
              /**
               * Update the attached in the store
               */
              this._attacheds.next([_attached, ...attacheds]);

              return of(_attached);
            })
          )
      )
    );
  }
  /**
   * queryRead
   * @param query
   */
  queryRead(query: string): Observable<Attached[]> {
    return this._httpClient
      .get<Attached[]>(this._url + `/queryRead/${query ? query : '*'}`)
      .pipe(
        tap((attacheds: Attached[]) => {
          if (attacheds) {
            this._attacheds.next(attacheds);
          } else {
            this._attacheds.next([]);
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
  ): Observable<Attached[]> {
    return this._httpClient
      .get<Attached[]>(
        this._url + `/byCompanyQueryRead/${id_company}/${query ? query : '*'}`
      )
      .pipe(
        tap((attacheds: Attached[]) => {
          if (attacheds) {
            this._attacheds.next(attacheds);
          } else {
            this._attacheds.next([]);
          }
        })
      );
  }
  /**
   * specificRead
   * @param id_attached
   */
  specificRead(id_attached: string): Observable<Attached> {
    return this._httpClient
      .get<Attached>(this._url + `/specificRead/${id_attached}`)
      .pipe(
        tap((attached: Attached) => {
          this._attached.next(attached);
          return attacheds;
        })
      );
  }
  /**
   * specificReadInLocal
   */
  specificReadInLocal(id_attached: string): Observable<Attached> {
    return this._attacheds.pipe(
      take(1),
      map((attacheds) => {
        /**
         * Find
         */
        const attached =
          attacheds.find((item) => item.id_attached == id_attached) || null;
        /**
         * Update
         */
        this._attached.next(attached!);
        /**
         * Return
         */
        return attached;
      }),
      switchMap((attached) => {
        if (!attached) {
          return throwError(
            () => 'No se encontro el elemento con el id ' + id_attached + '!'
          );
        }
        return of(attached);
      })
    );
  }
  /**
   * update
   * @param attached
   */
  update(attached: Attached): Observable<any> {
    return this.attacheds$.pipe(
      take(1),
      switchMap((attacheds) =>
        this._httpClient
          .patch(this._url + '/update', attached, {
            headers: this._headers,
          })
          .pipe(
            switchMap((response: any) => {
              /**
               * check the response body to match with the type
               */
              const _attached: Attached = response.body;
              /**
               * Find the index of the updated attached
               */
              const index = attacheds.findIndex(
                (item) => item.id_attached == attached.id_attached
              );
              /**
               * Update the attached
               */
              attacheds[index] = _attached;
              /**
               * Update the attacheds
               */
              this._attacheds.next(attacheds);

              /**
               * Update the attached
               */
              this._attached.next(_attached);

              return of(_attached);
            })
          )
      )
    );
  }
  /**
   * delete
   * @param id_user_
   * @param id_attached
   */
  delete(id_user_: string, id_attached: string): Observable<any> {
    return this.attacheds$.pipe(
      take(1),
      switchMap((attacheds) =>
        this._httpClient
          .delete(this._url + `/delete`, {
            params: { id_user_, id_attached },
          })
          .pipe(
            switchMap((response: any) => {
              if (response && response.body) {
                /**
                 * Find the index of the updated attached
                 */
                const index = attacheds.findIndex(
                  (item) => item.id_attached == id_attached
                );
                /**
                 * Delete the object of array
                 */
                attacheds.splice(index, 1);
                /**
                 * Update the attacheds
                 */
                this._attacheds.next(attacheds);
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
