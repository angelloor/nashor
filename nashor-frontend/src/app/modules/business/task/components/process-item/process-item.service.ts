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
import { processItem, processItems } from './process-item.data';
import { ProcessItem } from './process-item.types';

@Injectable({
  providedIn: 'root',
})
export class ProcessItemService {
  private _url: string;
  private _headers: HttpHeaders = new HttpHeaders({
    'Content-Type': 'application/json',
  });

  private _processItem: BehaviorSubject<ProcessItem> = new BehaviorSubject(
    processItem
  );
  private _processItems: BehaviorSubject<ProcessItem[]> = new BehaviorSubject(
    processItems
  );

  constructor(private _httpClient: HttpClient) {
    this._url = environment.urlBackend + '/app/business/process_item';
  }
  /**
   * Getter
   */
  get processItem$(): Observable<ProcessItem> {
    return this._processItem.asObservable();
  }
  /**
   * Getter for _processItems
   */
  get processItems$(): Observable<ProcessItem[]> {
    return this._processItems.asObservable();
  }
  /**
   * create
   */
  create(
    id_user_: string,
    id_official: string,
    id_process: string,
    id_task: string,
    id_level: string
  ): Observable<any> {
    return this._processItems.pipe(
      take(1),
      switchMap((processItems) =>
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
              const _processItem: ProcessItem = response.body;
              /**
               * Update the processItem in the store
               */
              this._processItems.next([...processItems, _processItem]);

              return of(_processItem);
            })
          )
      )
    );
  }
  /**
   * byOfficialRead
   * @param id_official
   */
  byOfficialRead(id_official: string): Observable<ProcessItem[]> {
    return this._httpClient
      .get<ProcessItem[]>(this._url + `/byOfficialRead/${id_official}`)
      .pipe(
        tap((processItems: ProcessItem[]) => {
          if (processItems) {
            this._processItems.next(processItems);
          } else {
            this._processItems.next([]);
          }
        })
      );
  }
  /**
   * byProcessRead
   * @param id_process
   */
  byProcessRead(id_process: string): Observable<ProcessItem[]> {
    return this._httpClient
      .get<ProcessItem[]>(this._url + `/byProcessRead/${id_process}`)
      .pipe(
        tap((processItems: ProcessItem[]) => {
          if (processItems) {
            this._processItems.next(processItems);
          } else {
            this._processItems.next([]);
          }
        })
      );
  }
  /**
   * byTaskRead
   * @param id_task
   */
  byTaskRead(id_task: string): Observable<ProcessItem[]> {
    return this._httpClient
      .get<ProcessItem[]>(this._url + `/byTaskRead/${id_task}`)
      .pipe(
        tap((processItems: ProcessItem[]) => {
          if (processItems) {
            this._processItems.next(processItems);
          } else {
            this._processItems.next([]);
          }
        })
      );
  }
  /**
   * byLevelRead
   * @param id_level
   */
  byLevelRead(id_level: string): Observable<ProcessItem[]> {
    return this._httpClient
      .get<ProcessItem[]>(this._url + `/byLevelRead/${id_level}`)
      .pipe(
        tap((processItems: ProcessItem[]) => {
          if (processItems) {
            this._processItems.next(processItems);
          } else {
            this._processItems.next([]);
          }
        })
      );
  }
  /**
   * byItemRead
   * @param id_item
   */
  byItemRead(id_item: string): Observable<ProcessItem[]> {
    return this._httpClient
      .get<ProcessItem[]>(this._url + `/byItemRead/${id_item}`)
      .pipe(
        tap((processItems: ProcessItem[]) => {
          if (processItems) {
            this._processItems.next(processItems);
          } else {
            this._processItems.next([]);
          }
        })
      );
  }
  /**
   * specificRead
   * @param id_processItem
   */
  specificRead(id_processItem: string): Observable<ProcessItem> {
    return this._httpClient
      .get<ProcessItem>(this._url + `/specificRead/${id_processItem}`)
      .pipe(
        tap((processItem: ProcessItem) => {
          this._processItem.next(processItem);
          return processItems;
        })
      );
  }
  /**
   * specificReadInLocal
   */
  specificReadInLocal(id_processItem: string): Observable<ProcessItem> {
    return this._processItems.pipe(
      take(1),
      map((processItems) => {
        /**
         * Find
         */
        const processItem =
          processItems.find((item) => item.id_process_item == id_processItem) ||
          null;
        /**
         * Update
         */
        this._processItem.next(processItem!);
        /**
         * Return
         */
        return processItem;
      }),
      switchMap((processItem) => {
        if (!processItem) {
          return throwError(
            () => 'No se encontro el elemento con el id ' + id_processItem + '!'
          );
        }
        return of(processItem);
      })
    );
  }
  /**
   * update
   * @param processItem
   */
  update(processItem: ProcessItem): Observable<any> {
    return this.processItems$.pipe(
      take(1),
      switchMap((processItems) =>
        this._httpClient
          .patch(this._url + '/update', processItem, {
            headers: this._headers,
          })
          .pipe(
            switchMap((response: any) => {
              /**
               * check the response body to match with the type
               */
              const _processItem: ProcessItem = response.body;
              /**
               * Find the index of the updated processItem
               */
              const index = processItems.findIndex(
                (item) => item.id_process_item == processItem.id_process_item
              );
              /**
               * Update the processItem
               */
              processItems[index] = _processItem;
              /**
               * Update the processItems
               */
              this._processItems.next(processItems);

              /**
               * Update the processItem
               */
              this._processItem.next(_processItem);

              return of(_processItem);
            })
          )
      )
    );
  }
  /**
   * delete
   * @param id_user_
   * @param id_process_item
   */
  delete(id_user_: string, id_process_item: string): Observable<any> {
    return this.processItems$.pipe(
      take(1),
      switchMap((processItems) =>
        this._httpClient
          .delete(this._url + `/delete`, {
            params: { id_user_, id_process_item },
          })
          .pipe(
            switchMap((response: any) => {
              if (response && response.body) {
                /**
                 * Find the index of the updated processItem
                 */
                const index = processItems.findIndex(
                  (item) => item.id_process_item == id_process_item
                );
                /**
                 * Delete the object of array
                 */
                processItems.splice(index, 1);
                /**
                 * Update the processItems
                 */
                this._processItems.next(processItems);
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
