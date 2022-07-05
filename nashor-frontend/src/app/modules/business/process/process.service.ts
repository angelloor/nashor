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
import { process, processs } from './process.data';
import { Process } from './process.types';

@Injectable({
  providedIn: 'root',
})
export class ProcessService {
  private _url: string;
  private _headers: HttpHeaders = new HttpHeaders({
    'Content-Type': 'application/json',
  });

  private _process: BehaviorSubject<Process> = new BehaviorSubject(process);
  private _processs: BehaviorSubject<Process[]> = new BehaviorSubject(processs);

  constructor(private _httpClient: HttpClient) {
    this._url = environment.urlBackend + '/app/business/process';
  }
  /**
   * Getter
   */
  get process$(): Observable<Process> {
    return this._process.asObservable();
  }
  /**
   * Getter for _processs
   */
  get processs$(): Observable<Process[]> {
    return this._processs.asObservable();
  }
  /**
   * create
   */
  create(id_user_: string): Observable<any> {
    return this._processs.pipe(
      take(1),
      switchMap((processs) =>
        this._httpClient
          .post(
            this._url + '/create',
            {
              id_user_: parseInt(id_user_),
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
              const _process: Process = response.body;
              console.log(_process);
              /**
               * Update the process in the store
               */
              this._processs.next([_process, ...processs]);

              return of(_process);
            })
          )
      )
    );
  }
  /**
   * queryRead
   * @param query
   */
  queryRead(query: string): Observable<Process[]> {
    return this._httpClient
      .get<Process[]>(this._url + `/queryRead/${query ? query : '*'}`)
      .pipe(
        tap((processs: Process[]) => {
          if (processs) {
            this._processs.next(processs);
          } else {
            this._processs.next([]);
          }
        })
      );
  }
  /**
   * byProcessTypeQueryRead
   * @param id_process_type
   * @param query
   */
  byProcessTypeQueryRead(
    id_process_type: string,
    query: string
  ): Observable<Process[]> {
    return this._httpClient
      .get<Process[]>(
        this._url +
          `/byProcessTypeQueryRead/${id_process_type}/${query ? query : '*'}`
      )
      .pipe(
        tap((processs: Process[]) => {
          if (processs) {
            this._processs.next(processs);
          } else {
            this._processs.next([]);
          }
        })
      );
  }
  /**
   * byOfficialQueryRead
   * @param id_official
   * @param query
   */
  byOfficialQueryRead(
    id_official: string,
    query: string
  ): Observable<Process[]> {
    return this._httpClient
      .get<Process[]>(
        this._url + `/byOfficialQueryRead/${id_official}/${query ? query : '*'}`
      )
      .pipe(
        tap((processs: Process[]) => {
          if (processs) {
            this._processs.next(processs);
          } else {
            this._processs.next([]);
          }
        })
      );
  }
  /**
   * byFlowVersionQueryRead
   * @param id_flow_version
   * @param query
   */
  byFlowVersionQueryRead(
    id_flow_version: string,
    query: string
  ): Observable<Process[]> {
    return this._httpClient
      .get<Process[]>(
        this._url +
          `/byFlowVersionQueryRead/${id_flow_version}/${query ? query : '*'}`
      )
      .pipe(
        tap((processs: Process[]) => {
          if (processs) {
            this._processs.next(processs);
          } else {
            this._processs.next([]);
          }
        })
      );
  }
  /**
   * specificRead
   * @param id_process
   */
  specificRead(id_process: string): Observable<Process> {
    return this._httpClient
      .get<Process>(this._url + `/specificRead/${id_process}`)
      .pipe(
        tap((process: Process) => {
          this._process.next(process);
          return processs;
        })
      );
  }
  /**
   * specificReadInLocal
   */
  specificReadInLocal(id_process: string): Observable<Process> {
    return this._processs.pipe(
      take(1),
      map((processs) => {
        /**
         * Find
         */
        const process =
          processs.find((item) => item.id_process == id_process) || null;
        /**
         * Update
         */
        this._process.next(process!);
        /**
         * Return
         */
        return process;
      }),
      switchMap((process) => {
        if (!process) {
          return throwError(
            () => 'No se encontro el elemento con el id ' + id_process + '!'
          );
        }
        return of(process);
      })
    );
  }
  /**
   * update
   * @param process
   */
  update(process: Process): Observable<any> {
    return this.processs$.pipe(
      take(1),
      switchMap((processs) =>
        this._httpClient
          .patch(this._url + '/update', process, {
            headers: this._headers,
          })
          .pipe(
            switchMap((response: any) => {
              /**
               * check the response body to match with the type
               */
              const _process: Process = response.body;
              console.log(_process);
              /**
               * Find the index of the updated process
               */
              const index = processs.findIndex(
                (item) => item.id_process == process.id_process
              );
              console.log(index);
              /**
               * Update the process
               */
              processs[index] = _process;
              /**
               * Update the processs
               */
              this._processs.next(processs);

              /**
               * Update the process
               */
              this._process.next(_process);

              return of(_process);
            })
          )
      )
    );
  }
  /**
   * delete
   * @param id_user_
   * @param id_process
   */
  delete(id_user_: string, id_process: string): Observable<any> {
    return this.processs$.pipe(
      take(1),
      switchMap((processs) =>
        this._httpClient
          .delete(this._url + `/delete`, {
            params: { id_user_, id_process },
          })
          .pipe(
            switchMap((response: any) => {
              if (response && response.body) {
                /**
                 * Find the index of the updated process
                 */
                const index = processs.findIndex(
                  (item) => item.id_process == id_process
                );
                console.log(index);
                /**
                 * Delete the object of array
                 */
                processs.splice(index, 1);
                /**
                 * Update the processs
                 */
                this._processs.next(processs);
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
