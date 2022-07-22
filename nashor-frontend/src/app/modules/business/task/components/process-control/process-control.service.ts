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
import { processControl, processControls } from './process-control.data';
import { ProcessControl } from './process-control.types';

@Injectable({
  providedIn: 'root',
})
export class ProcessControlService {
  private _url: string;
  private _headers: HttpHeaders = new HttpHeaders({
    'Content-Type': 'application/json',
  });

  private _processControl: BehaviorSubject<ProcessControl> =
    new BehaviorSubject(processControl);
  private _processControls: BehaviorSubject<ProcessControl[]> =
    new BehaviorSubject(processControls);

  constructor(private _httpClient: HttpClient) {
    this._url = environment.urlBackend + '/app/business/process_control';
  }
  /**
   * Getter
   */
  get processControl$(): Observable<ProcessControl> {
    return this._processControl.asObservable();
  }
  /**
   * Getter for _processControls
   */
  get processControls$(): Observable<ProcessControl[]> {
    return this._processControls.asObservable();
  }
  /**
   * create
   */
  create(
    id_user_: string,
    id_official: string,
    id_process: string,
    id_task: string,
    id_level: string,
    id_control: string,
    value_process_control: string
  ): Observable<any> {
    return this._processControls.pipe(
      take(1),
      switchMap((processControls) =>
        this._httpClient
          .post(
            this._url + '/create',
            {
              id_user_: parseInt(id_user_),
              official: {
                id_official: parseInt(id_official),
              },
              process: {
                id_process: parseInt(id_process),
              },
              task: {
                id_task: parseInt(id_task),
              },
              level: {
                id_level: parseInt(id_level),
              },
              control: {
                id_control: parseInt(id_control),
              },
              value_process_control,
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
              const _processControl: ProcessControl = response.body;
              /**
               * Update the processControl in the store
               */
              this._processControls.next([_processControl, ...processControls]);

              return of(_processControl);
            })
          )
      )
    );
  }
  /**
   * byOfficialRead
   * @param id_official
   */
  byOfficialRead(id_official: string): Observable<ProcessControl[]> {
    return this._httpClient
      .get<ProcessControl[]>(this._url + `/byOfficialRead/${id_official}`)
      .pipe(
        tap((processControls: ProcessControl[]) => {
          if (processControls) {
            this._processControls.next(processControls);
          } else {
            this._processControls.next([]);
          }
        })
      );
  }
  /**
   * byProcessRead
   * @param id_process
   */
  byProcessRead(id_process: string): Observable<ProcessControl[]> {
    return this._httpClient
      .get<ProcessControl[]>(this._url + `/byProcessRead/${id_process}`)
      .pipe(
        tap((processControls: ProcessControl[]) => {
          if (processControls) {
            this._processControls.next(processControls);
          } else {
            this._processControls.next([]);
          }
        })
      );
  }
  /**
   * byTaskRead
   * @param id_task
   */
  byTaskRead(id_task: string): Observable<ProcessControl[]> {
    return this._httpClient
      .get<ProcessControl[]>(this._url + `/byTaskRead/${id_task}`)
      .pipe(
        tap((processControls: ProcessControl[]) => {
          if (processControls) {
            this._processControls.next(processControls);
          } else {
            this._processControls.next([]);
          }
        })
      );
  }
  /**
   * byLevelRead
   * @param id_level
   */
  byLevelRead(id_level: string): Observable<ProcessControl[]> {
    return this._httpClient
      .get<ProcessControl[]>(this._url + `/byLevelRead/${id_level}`)
      .pipe(
        tap((processControls: ProcessControl[]) => {
          if (processControls) {
            this._processControls.next(processControls);
          } else {
            this._processControls.next([]);
          }
        })
      );
  }
  /**
   * byControlRead
   * @param id_control
   */
  byControlRead(id_control: string): Observable<ProcessControl[]> {
    return this._httpClient
      .get<ProcessControl[]>(this._url + `/byControlRead/${id_control}`)
      .pipe(
        tap((processControls: ProcessControl[]) => {
          if (processControls) {
            this._processControls.next(processControls);
          } else {
            this._processControls.next([]);
          }
        })
      );
  }
  /**
   * specificRead
   * @param id_processControl
   */
  specificRead(id_processControl: string): Observable<ProcessControl> {
    return this._httpClient
      .get<ProcessControl>(this._url + `/specificRead/${id_processControl}`)
      .pipe(
        tap((processControl: ProcessControl) => {
          this._processControl.next(processControl);
          return processControls;
        })
      );
  }
  /**
   * specificReadInLocal
   */
  specificReadInLocal(id_processControl: string): Observable<ProcessControl> {
    return this._processControls.pipe(
      take(1),
      map((processControls) => {
        /**
         * Find
         */
        const processControl =
          processControls.find(
            (item) => item.id_process_control == id_processControl
          ) || null;
        /**
         * Update
         */
        this._processControl.next(processControl!);
        /**
         * Return
         */
        return processControl;
      }),
      switchMap((processControl) => {
        if (!processControl) {
          return throwError(
            () =>
              'No se encontro el elemento con el id ' + id_processControl + '!'
          );
        }
        return of(processControl);
      })
    );
  }
  /**
   * update
   * @param processControl
   */
  update(processControl: ProcessControl): Observable<any> {
    return this.processControls$.pipe(
      take(1),
      switchMap((processControls) =>
        this._httpClient
          .patch(this._url + '/update', processControl, {
            headers: this._headers,
          })
          .pipe(
            switchMap((response: any) => {
              /**
               * check the response body to match with the type
               */
              const _processControl: ProcessControl = response.body;
              /**
               * Find the index of the updated processControl
               */
              const index = processControls.findIndex(
                (item) =>
                  item.id_process_control == processControl.id_process_control
              );
              /**
               * Update the processControl
               */
              processControls[index] = _processControl;
              /**
               * Update the processControls
               */
              this._processControls.next(processControls);

              /**
               * Update the processControl
               */
              this._processControl.next(_processControl);

              return of(_processControl);
            })
          )
      )
    );
  }
  /**
   * delete
   * @param id_user_
   * @param id_process_control
   */
  delete(id_user_: string, id_process_control: string): Observable<any> {
    return this.processControls$.pipe(
      take(1),
      switchMap((processControls) =>
        this._httpClient
          .delete(this._url + `/delete`, {
            params: { id_user_, id_process_control },
          })
          .pipe(
            switchMap((response: any) => {
              if (response && response.body) {
                /**
                 * Find the index of the updated processControl
                 */
                const index = processControls.findIndex(
                  (item) => item.id_process_control == id_process_control
                );
                /**
                 * Delete the object of array
                 */
                processControls.splice(index, 1);
                /**
                 * Update the processControls
                 */
                this._processControls.next(processControls);
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
