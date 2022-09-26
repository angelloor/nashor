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
import { control, controls } from './control.data';
import { Control } from './control.types';

@Injectable({
  providedIn: 'root',
})
export class ControlService {
  private _url: string;
  private _headers: HttpHeaders = new HttpHeaders({
    'Content-Type': 'application/json',
  });

  private _control: BehaviorSubject<Control> = new BehaviorSubject(control);
  private _controls: BehaviorSubject<Control[]> = new BehaviorSubject(controls);

  constructor(private _httpClient: HttpClient) {
    this._url = environment.urlBackend + '/app/business/control';
  }
  /**
   * Getter
   */
  get control$(): Observable<Control> {
    return this._control.asObservable();
  }
  /**
   * Getter for _controls
   */
  get controls$(): Observable<Control[]> {
    return this._controls.asObservable();
  }
  /**
   * create
   */
  create(id_user_: string, id_company: string): Observable<any> {
    return this._controls.pipe(
      take(1),
      switchMap((controls) =>
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
              const _control: Control = response.body;
              /**
               * Update the control in the store
               */
              this._controls.next([_control, ...controls]);

              return of(_control);
            })
          )
      )
    );
  }
  /**
   * queryRead
   * @param query
   */
  queryRead(query: string): Observable<Control[]> {
    return this._httpClient
      .get<Control[]>(this._url + `/queryRead/${query ? query : '*'}`)
      .pipe(
        tap((controls: Control[]) => {
          if (controls) {
            this._controls.next(controls);
          } else {
            this._controls.next([]);
          }
        })
      );
  }
  /**
   * byCompanyQueryRead
   * @param id_company
   * @param query
   */
  byCompanyQueryRead(id_company: string, query: string): Observable<Control[]> {
    return this._httpClient
      .get<Control[]>(
        this._url + `/byCompanyQueryRead/${id_company}/${query ? query : '*'}`
      )
      .pipe(
        tap((controls: Control[]) => {
          if (controls) {
            this._controls.next(controls);
          } else {
            this._controls.next([]);
          }
        })
      );
  }
  /**
   * specificRead
   * @param id_control
   */
  specificRead(id_control: string): Observable<Control> {
    return this._httpClient
      .get<Control>(this._url + `/specificRead/${id_control}`)
      .pipe(
        tap((control: Control) => {
          this._control.next(control);
          return control;
        })
      );
  }
  /**
   * specificReadInLocal
   */
  specificReadInLocal(id_control: string): Observable<Control> {
    return this._controls.pipe(
      take(1),
      map((controls) => {
        /**
         * Find
         */
        const control =
          controls.find((item) => item.id_control == id_control) || null;
        /**
         * Update
         */
        this._control.next(control!);
        /**
         * Return
         */
        return control;
      }),
      switchMap((control) => {
        if (!control) {
          return throwError(
            () => 'No se encontro el elemento con el id ' + id_control + '!'
          );
        }
        return of(control);
      })
    );
  }
  /**
   * update
   * @param control
   */
  update(control: Control): Observable<any> {
    return this.controls$.pipe(
      take(1),
      switchMap((controls) =>
        this._httpClient
          .patch(this._url + '/update', control, {
            headers: this._headers,
          })
          .pipe(
            switchMap((response: any) => {
              /**
               * check the response body to match with the type
               */
              const _control: Control = response.body;
              /**
               * Find the index of the updated control
               */
              const index = controls.findIndex(
                (item) => item.id_control == control.id_control
              );
              /**
               * Update the control
               */
              controls[index] = _control;
              /**
               * Update the controls
               */
              this._controls.next(controls);

              /**
               * Update the control
               */
              this._control.next(_control);

              return of(_control);
            })
          )
      )
    );
  }
  /**
   * delete
   * @param id_user_
   * @param id_control
   */
  delete(id_user_: string, id_control: string): Observable<any> {
    return this.controls$.pipe(
      take(1),
      switchMap((controls) =>
        this._httpClient
          .delete(this._url + `/delete`, {
            params: { id_user_, id_control },
          })
          .pipe(
            switchMap((response: any) => {
              if (response && response.body) {
                /**
                 * Find the index of the updated control
                 */
                const index = controls.findIndex(
                  (item) => item.id_control == id_control
                );
                /**
                 * Delete the object of array
                 */
                controls.splice(index, 1);
                /**
                 * Update the controls
                 */
                this._controls.next(controls);
                return of(response.body);
              } else {
                return of(false);
              }
            })
          )
      )
    );
  }
  /**
   * cascadeDelete
   * @param id_user_
   * @param id_control
   */
  cascadeDelete(id_user_: string, id_control: string): Observable<any> {
    return this.controls$.pipe(
      take(1),
      switchMap((controls) =>
        this._httpClient
          .delete(this._url + `/cascadeDelete`, {
            params: { id_user_, id_control },
          })
          .pipe(
            switchMap((response: any) => {
              if (response && response.body) {
                /**
                 * Find the index of the updated control
                 */
                const index = controls.findIndex(
                  (item) => item.id_control == id_control
                );
                /**
                 * Delete the object of array
                 */
                controls.splice(index, 1);
                /**
                 * Update the controls
                 */
                this._controls.next(controls);
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
