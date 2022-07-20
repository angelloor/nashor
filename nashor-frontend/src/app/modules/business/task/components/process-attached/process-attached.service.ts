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
import { processAttached, processAttacheds } from './process-attached.data';
import { ProcessAttached } from './process-attached.types';

@Injectable({
  providedIn: 'root',
})
export class ProcessAttachedService {
  private _url: string;
  private _headers: HttpHeaders = new HttpHeaders({
    'Content-Type': 'application/json',
  });

  private _processAttached: BehaviorSubject<ProcessAttached> =
    new BehaviorSubject(processAttached);
  private _processAttacheds: BehaviorSubject<ProcessAttached[]> =
    new BehaviorSubject(processAttacheds);

  constructor(private _httpClient: HttpClient) {
    this._url = environment.urlBackend + '/app/business/process_attached';
  }
  /**
   * Getter
   */
  get processAttached$(): Observable<ProcessAttached> {
    return this._processAttached.asObservable();
  }
  /**
   * Getter for _processAttacheds
   */
  get processAttacheds$(): Observable<ProcessAttached[]> {
    return this._processAttacheds.asObservable();
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
    id_attached: string,
    file_name: string,
    length_mb: string,
    extension: string,
    file: File
  ): Observable<any> {
    var formData = new FormData();

    formData.append('id_user_', id_user_);
    formData.append('id_official', id_official);
    formData.append('id_process', id_process);
    formData.append('id_task', id_task);
    formData.append('id_level', id_level);
    formData.append('id_attached', id_attached);
    formData.append('file_name', file_name);
    formData.append('length_mb', length_mb);
    formData.append('extension', extension);
    formData.append('file', file);

    return this._processAttacheds.pipe(
      take(1),
      switchMap((processAttacheds) =>
        this._httpClient.post(this._url + '/create', formData).pipe(
          switchMap((response: any) => {
            /**
             * check the response body to match with the type
             */
            const _processAttached: ProcessAttached = response.body;
            /**
             * Update the processAttached in the store
             */
            this._processAttacheds.next([
              _processAttached,
              ...processAttacheds,
            ]);

            return of(_processAttached);
          })
        )
      )
    );
  }
  /**
   * byOfficialRead
   * @param id_official
   */
  byOfficialRead(id_official: string): Observable<ProcessAttached[]> {
    return this._httpClient
      .get<ProcessAttached[]>(this._url + `/byOfficialRead/${id_official}/`)
      .pipe(
        tap((processAttacheds: ProcessAttached[]) => {
          if (processAttacheds) {
            this._processAttacheds.next(processAttacheds);
          } else {
            this._processAttacheds.next([]);
          }
        })
      );
  }
  /**
   * byProcessRead
   * @param id_process
   */
  byProcessRead(id_process: string): Observable<ProcessAttached[]> {
    return this._httpClient
      .get<ProcessAttached[]>(this._url + `/byProcessRead/${id_process}/`)
      .pipe(
        tap((processAttacheds: ProcessAttached[]) => {
          if (processAttacheds) {
            this._processAttacheds.next(processAttacheds);
          } else {
            this._processAttacheds.next([]);
          }
        })
      );
  }
  /**
   * byTaskRead
   * @param id_task
   */
  byTaskRead(id_task: string): Observable<ProcessAttached[]> {
    return this._httpClient
      .get<ProcessAttached[]>(this._url + `/byTaskRead/${id_task}/`)
      .pipe(
        tap((processAttacheds: ProcessAttached[]) => {
          if (processAttacheds) {
            this._processAttacheds.next(processAttacheds);
          } else {
            this._processAttacheds.next([]);
          }
        })
      );
  }
  /**
   * byLevelRead
   * @param id_level
   */
  byLevelRead(id_level: string): Observable<ProcessAttached[]> {
    return this._httpClient
      .get<ProcessAttached[]>(this._url + `/byLevelRead/${id_level}/`)
      .pipe(
        tap((processAttacheds: ProcessAttached[]) => {
          if (processAttacheds) {
            this._processAttacheds.next(processAttacheds);
          } else {
            this._processAttacheds.next([]);
          }
        })
      );
  }
  /**
   * byAttachedRead
   * @param id_attached
   */
  byAttachedRead(id_attached: string): Observable<ProcessAttached[]> {
    return this._httpClient
      .get<ProcessAttached[]>(this._url + `/byAttachedRead/${id_attached}/`)
      .pipe(
        tap((processAttacheds: ProcessAttached[]) => {
          if (processAttacheds) {
            this._processAttacheds.next(processAttacheds);
          } else {
            this._processAttacheds.next([]);
          }
        })
      );
  }
  /**
   * specificRead
   * @param id_processAttached
   */
  specificRead(id_processAttached: string): Observable<ProcessAttached> {
    return this._httpClient
      .get<ProcessAttached>(this._url + `/specificRead/${id_processAttached}`)
      .pipe(
        tap((processAttached: ProcessAttached) => {
          this._processAttached.next(processAttached);
          return processAttacheds;
        })
      );
  }
  /**
   * specificReadInLocal
   */
  specificReadInLocal(id_processAttached: string): Observable<ProcessAttached> {
    return this._processAttacheds.pipe(
      take(1),
      map((processAttacheds) => {
        /**
         * Find
         */
        const processAttached =
          processAttacheds.find(
            (item) => item.id_process_attached == id_processAttached
          ) || null;
        /**
         * Update
         */
        this._processAttached.next(processAttached!);
        /**
         * Return
         */
        return processAttached;
      }),
      switchMap((processAttached) => {
        if (!processAttached) {
          return throwError(
            () =>
              'No se encontro el elemento con el id ' + id_processAttached + '!'
          );
        }
        return of(processAttached);
      })
    );
  }
  /**
   * update
   * @param processAttached
   */
  update(processAttached: ProcessAttached): Observable<any> {
    return this.processAttacheds$.pipe(
      take(1),
      switchMap((processAttacheds) =>
        this._httpClient
          .patch(this._url + '/update', processAttached, {
            headers: this._headers,
          })
          .pipe(
            switchMap((response: any) => {
              /**
               * check the response body to match with the type
               */
              const _processAttached: ProcessAttached = response.body;
              /**
               * Find the index of the updated processAttached
               */
              const index = processAttacheds.findIndex(
                (item) =>
                  item.id_process_attached ==
                  processAttached.id_process_attached
              );
              /**
               * Update the processAttached
               */
              processAttacheds[index] = _processAttached;
              /**
               * Update the processAttacheds
               */
              this._processAttacheds.next(processAttacheds);

              /**
               * Update the processAttached
               */
              this._processAttached.next(_processAttached);

              return of(_processAttached);
            })
          )
      )
    );
  }
  /**
   * delete
   * @param id_user_
   * @param id_process_attached
   */
  delete(id_user_: string, id_process_attached: string): Observable<any> {
    return this.processAttacheds$.pipe(
      take(1),
      switchMap((processAttacheds) =>
        this._httpClient
          .delete(this._url + `/delete`, {
            params: { id_user_, id_process_attached },
          })
          .pipe(
            switchMap((response: any) => {
              if (response && response.body) {
                /**
                 * Find the index of the updated processAttached
                 */
                const index = processAttacheds.findIndex(
                  (item) => item.id_process_attached == id_process_attached
                );
                /**
                 * Delete the object of array
                 */
                processAttacheds.splice(index, 1);
                /**
                 * Update the processAttacheds
                 */
                this._processAttacheds.next(processAttacheds);
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
   * downloadFile
   * @param server_path
   * @returns
   */
  downloadFile(server_path: string): any {
    return this._httpClient
      .post(
        this._url + `/downloadFile`,
        { server_path },
        {
          responseType: 'blob',
          headers: new HttpHeaders().append('Content-Type', 'application/json'),
        }
      )
      .pipe(map((data) => data));
  }
}
