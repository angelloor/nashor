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
  columnProcessItem,
  columnProcessItems
} from './column-process-item.data';
import { ColumnProcessItem } from './column-process-item.types';

@Injectable({
  providedIn: 'root',
})
export class ColumnProcessItemService {
  private _url: string;
  private _headers: HttpHeaders = new HttpHeaders({
    'Content-Type': 'application/json',
  });

  private _columnProcessItem: BehaviorSubject<ColumnProcessItem> =
    new BehaviorSubject(columnProcessItem);
  private _columnProcessItems: BehaviorSubject<ColumnProcessItem[]> =
    new BehaviorSubject(columnProcessItems);

  constructor(private _httpClient: HttpClient) {
    this._url = environment.urlBackend + '/app/business/column_process_item';
  }
  /**
   * Getter
   */
  get columnProcessItem$(): Observable<ColumnProcessItem> {
    return this._columnProcessItem.asObservable();
  }
  /**
   * Getter for _columnProcessItems
   */
  get columnProcessItems$(): Observable<ColumnProcessItem[]> {
    return this._columnProcessItems.asObservable();
  }
  /**
   * create
   */
  create(
    id_user_: string,
    id_plugin_item_column: string,
    id_process_item: string,
    value_column_process_item: string
  ): Observable<any> {
    return this._columnProcessItems.pipe(
      take(1),
      switchMap((columnProcessItems) =>
        this._httpClient
          .post(
            this._url + '/create',
            {
              id_user_: parseInt(id_user_),
              plugin_item_column: {
                id_plugin_item_column: parseInt(id_plugin_item_column),
              },
              process_item: {
                id_process_item: parseInt(id_process_item),
              },
              value_column_process_item
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
              const _columnProcessItem: ColumnProcessItem = response.body;
              /**
               * Update the columnProcessItem in the store
               */
              this._columnProcessItems.next([
                _columnProcessItem,
                ...columnProcessItems,
              ]);

              return of(_columnProcessItem);
            })
          )
      )
    );
  }
  /**
   * queryRead
   * @param query
   */
  queryRead(query: string): Observable<ColumnProcessItem[]> {
    return this._httpClient
      .get<ColumnProcessItem[]>(this._url + `/queryRead/${query ? query : '*'}`)
      .pipe(
        tap((columnProcessItems: ColumnProcessItem[]) => {
          if (columnProcessItems.length > 0) {
            this._columnProcessItems.next(columnProcessItems);
          }
        })
      );
  }
  /**
   * byPluginItemColumnQueryRead
   * @param id_plugin_item_column
   * @param query
   */
  byPluginItemColumnQueryRead(
    id_plugin_item_column: string,
    query: string
  ): Observable<ColumnProcessItem[]> {
    return this._httpClient
      .get<ColumnProcessItem[]>(
        this._url +
          `/byPluginItemColumnQueryRead/${id_plugin_item_column}/${
            query ? query : '*'
          }`
      )
      .pipe(
        tap((columnProcessItems: ColumnProcessItem[]) => {
          if (columnProcessItems.length > 0) {
            this._columnProcessItems.next(columnProcessItems);
          }
        })
      );
  }
  /**
   * byProcessItemQueryRead
   * @param id_process_item
   * @param query
   */
  byProcessItemQueryRead(
    id_process_item: string,
    query: string
  ): Observable<ColumnProcessItem[]> {
    return this._httpClient
      .get<ColumnProcessItem[]>(
        this._url +
          `/byProcessItemQueryRead/${id_process_item}/${query ? query : '*'}`
      )
      .pipe(
        tap((columnProcessItems: ColumnProcessItem[]) => {
          if (columnProcessItems.length > 0) {
            this._columnProcessItems.next(columnProcessItems);
          }
        })
      );
  }
  /**
   * byPluginItemColumnAndProcessItemRead
   * @param id_plugin_item_column
   * @param id_process_item
   */
  byPluginItemColumnAndProcessItemRead(
    id_plugin_item_column: string,
    id_process_item: string
  ): Observable<ColumnProcessItem> {
    return this._httpClient
      .get<ColumnProcessItem>(
        this._url +
          `/byPluginItemColumnAndProcessItemRead/${id_plugin_item_column}/${id_process_item}`
      )
      .pipe(
        tap((columnProcessItem: ColumnProcessItem) => {
          return columnProcessItem;
        })
      );
  }
  /**
   * specificRead
   * @param id_columnProcessItem
   */
  specificRead(id_columnProcessItem: string): Observable<ColumnProcessItem> {
    return this._httpClient
      .get<ColumnProcessItem>(
        this._url + `/specificRead/${id_columnProcessItem}`
      )
      .pipe(
        tap((columnProcessItem: ColumnProcessItem) => {
          this._columnProcessItem.next(columnProcessItem);
          return columnProcessItems;
        })
      );
  }
  /**
   * specificReadInLocal
   */
  specificReadInLocal(
    id_columnProcessItem: string
  ): Observable<ColumnProcessItem> {
    return this._columnProcessItems.pipe(
      take(1),
      map((columnProcessItems) => {
        /**
         * Find
         */
        const columnProcessItem =
          columnProcessItems.find(
            (item) => item.id_column_process_item == id_columnProcessItem
          ) || null;
        /**
         * Update
         */
        this._columnProcessItem.next(columnProcessItem!);
        /**
         * Return
         */
        return columnProcessItem;
      }),
      switchMap((columnProcessItem) => {
        if (!columnProcessItem) {
          return throwError(
            () =>
              'No se encontro el elemento con el id ' +
              id_columnProcessItem +
              '!'
          );
        }
        return of(columnProcessItem);
      })
    );
  }
  /**
   * update
   * @param columnProcessItem
   */
  update(columnProcessItem: ColumnProcessItem): Observable<any> {
    return this.columnProcessItems$.pipe(
      take(1),
      switchMap((columnProcessItems) =>
        this._httpClient
          .patch(this._url + '/update', columnProcessItem, {
            headers: this._headers,
          })
          .pipe(
            switchMap((response: any) => {
              /**
               * check the response body to match with the type
               */
              const _columnProcessItem: ColumnProcessItem = response.body;
              /**
               * Find the index of the updated columnProcessItem
               */
              const index = columnProcessItems.findIndex(
                (item) =>
                  item.id_column_process_item ==
                  columnProcessItem.id_column_process_item
              );
              /**
               * Update the columnProcessItem
               */
              columnProcessItems[index] = _columnProcessItem;
              /**
               * Update the columnProcessItems
               */
              this._columnProcessItems.next(columnProcessItems);

              /**
               * Update the columnProcessItem
               */
              this._columnProcessItem.next(_columnProcessItem);

              return of(_columnProcessItem);
            })
          )
      )
    );
  }
  /**
   * delete
   * @param id_user_
   * @param id_column_process_item
   */
  delete(id_user_: string, id_column_process_item: string): Observable<any> {
    return this.columnProcessItems$.pipe(
      take(1),
      switchMap((columnProcessItems) =>
        this._httpClient
          .delete(this._url + `/delete`, {
            params: { id_user_, id_column_process_item },
          })
          .pipe(
            switchMap((response: any) => {
              if (response && response.body) {
                /**
                 * Find the index of the updated columnProcessItem
                 */
                const index = columnProcessItems.findIndex(
                  (item) =>
                    item.id_column_process_item == id_column_process_item
                );
                /**
                 * Delete the object of array
                 */
                columnProcessItems.splice(index, 1);
                /**
                 * Update the columnProcessItems
                 */
                this._columnProcessItems.next(columnProcessItems);
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
