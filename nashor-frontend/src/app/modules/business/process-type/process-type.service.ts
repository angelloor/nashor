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
import { processType, processTypes } from './process-type.data';
import { ProcessType } from './process-type.types';

@Injectable({
  providedIn: 'root',
})
export class ProcessTypeService {
  private _url: string;
  private _headers: HttpHeaders = new HttpHeaders({
    'Content-Type': 'application/json',
  });

  private _processType: BehaviorSubject<ProcessType> = new BehaviorSubject(
    processType
  );
  private _processTypes: BehaviorSubject<ProcessType[]> = new BehaviorSubject(
    processTypes
  );

  constructor(private _httpClient: HttpClient) {
    this._url = environment.urlBackend + '/app/business/process_type';
  }
  /**
   * Getter
   */
  get processType$(): Observable<ProcessType> {
    return this._processType.asObservable();
  }
  /**
   * Getter for _processTypes
   */
  get processTypes$(): Observable<ProcessType[]> {
    return this._processTypes.asObservable();
  }
  /**
   * create
   */
  create(id_user_: string, id_company: string): Observable<any> {
    return this._processTypes.pipe(
      take(1),
      switchMap((processTypes) =>
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
              const _processType: ProcessType = response.body;
              /**
               * Update the processType in the store
               */
              this._processTypes.next([_processType, ...processTypes]);

              return of(_processType);
            })
          )
      )
    );
  }
  /**
   * queryRead
   * @param query
   */
  queryRead(query: string): Observable<ProcessType[]> {
    return this._httpClient
      .get<ProcessType[]>(this._url + `/queryRead/${query ? query : '*'}`)
      .pipe(
        tap((processTypes: ProcessType[]) => {
          if (processTypes) {
            this._processTypes.next(processTypes);
          } else {
            this._processTypes.next([]);
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
  ): Observable<ProcessType[]> {
    return this._httpClient
      .get<ProcessType[]>(
        this._url + `/byCompanyQueryRead/${id_company}/${query ? query : '*'}`
      )
      .pipe(
        tap((processTypes: ProcessType[]) => {
          if (processTypes) {
            this._processTypes.next(processTypes);
          } else {
            this._processTypes.next([]);
          }
        })
      );
  }
  /**
   * specificRead
   * @param id_processType
   */
  specificRead(id_processType: string): Observable<ProcessType> {
    return this._httpClient
      .get<ProcessType>(this._url + `/specificRead/${id_processType}`)
      .pipe(
        tap((processType: ProcessType) => {
          this._processType.next(processType);
          return processTypes;
        })
      );
  }
  /**
   * specificReadInLocal
   */
  specificReadInLocal(id_processType: string): Observable<ProcessType> {
    return this._processTypes.pipe(
      take(1),
      map((processTypes) => {
        /**
         * Find
         */
        const processType =
          processTypes.find((item) => item.id_process_type == id_processType) ||
          null;
        /**
         * Update
         */
        this._processType.next(processType!);
        /**
         * Return
         */
        return processType;
      }),
      switchMap((processType) => {
        if (!processType) {
          return throwError(
            () => 'No se encontro el elemento con el id ' + id_processType + '!'
          );
        }
        return of(processType);
      })
    );
  }
  /**
   * update
   * @param processType
   */
  update(processType: ProcessType): Observable<any> {
    return this.processTypes$.pipe(
      take(1),
      switchMap((processTypes) =>
        this._httpClient
          .patch(this._url + '/update', processType, {
            headers: this._headers,
          })
          .pipe(
            switchMap((response: any) => {
              /**
               * check the response body to match with the type
               */
              const _processType: ProcessType = response.body;
              /**
               * Find the index of the updated processType
               */
              const index = processTypes.findIndex(
                (item) => item.id_process_type == processType.id_process_type
              );
              /**
               * Update the processType
               */
              processTypes[index] = _processType;
              /**
               * Update the processTypes
               */
              this._processTypes.next(processTypes);

              /**
               * Update the processType
               */
              this._processType.next(_processType);

              return of(_processType);
            })
          )
      )
    );
  }
  /**
   * delete
   * @param id_user_
   * @param id_process_type
   */
  delete(id_user_: string, id_process_type: string): Observable<any> {
    return this.processTypes$.pipe(
      take(1),
      switchMap((processTypes) =>
        this._httpClient
          .delete(this._url + `/delete`, {
            params: { id_user_, id_process_type },
          })
          .pipe(
            switchMap((response: any) => {
              if (response && response.body) {
                /**
                 * Find the index of the updated processType
                 */
                const index = processTypes.findIndex(
                  (item) => item.id_process_type == id_process_type
                );
                /**
                 * Delete the object of array
                 */
                processTypes.splice(index, 1);
                /**
                 * Update the processTypes
                 */
                this._processTypes.next(processTypes);
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
