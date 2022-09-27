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
import { pluginItemColumn, pluginItemColumns } from './plugin-item-column.data';
import { PluginItemColumn } from './plugin-item-column.types';

@Injectable({
  providedIn: 'root',
})
export class PluginItemColumnService {
  private _url: string;
  private _headers: HttpHeaders = new HttpHeaders({
    'Content-Type': 'application/json',
  });

  private _pluginItemColumn: BehaviorSubject<PluginItemColumn> =
    new BehaviorSubject(pluginItemColumn);
  private _pluginItemColumns: BehaviorSubject<PluginItemColumn[]> =
    new BehaviorSubject(pluginItemColumns);

  constructor(private _httpClient: HttpClient) {
    this._url = environment.urlBackend + '/app/business/plugin_item_column';
  }
  /**
   * Getter
   */
  get pluginItemColumn$(): Observable<PluginItemColumn> {
    return this._pluginItemColumn.asObservable();
  }
  /**
   * Getter for _pluginItemColumns
   */
  get pluginItemColumns$(): Observable<PluginItemColumn[]> {
    return this._pluginItemColumns.asObservable();
  }
  /**
   * create
   */
  create(id_user_: string, id_plugin_item: string): Observable<any> {
    return this._pluginItemColumns.pipe(
      take(1),
      switchMap((pluginItemColumns) =>
        this._httpClient
          .post(
            this._url + '/create',
            {
              id_user_: parseInt(id_user_),
              plugin_item: {
                id_plugin_item: parseInt(id_plugin_item),
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
              const _pluginItemColumn: PluginItemColumn = response.body;
              /**
               * Update the pluginItemColumn in the store
               */
              this._pluginItemColumns.next([
                ...pluginItemColumns,
                _pluginItemColumn,
              ]);

              return of(_pluginItemColumn);
            })
          )
      )
    );
  }
  /**
   * queryRead
   * @param query
   */
  queryRead(query: string): Observable<PluginItemColumn[]> {
    return this._httpClient
      .get<PluginItemColumn[]>(this._url + `/queryRead/${query ? query : '*'}`)
      .pipe(
        tap((pluginItemColumns: PluginItemColumn[]) => {
          if (pluginItemColumns) {
            this._pluginItemColumns.next(pluginItemColumns);
          } else {
            this._pluginItemColumns.next([]);
          }
        })
      );
  }
  /**
   * byPluginItemQueryRead
   * @param id_plugin_item
   * @param query
   */
  byPluginItemQueryRead(
    id_plugin_item: string,
    query: string
  ): Observable<PluginItemColumn[]> {
    return this._httpClient
      .get<PluginItemColumn[]>(
        this._url +
          `/byPluginItemQueryRead/${id_plugin_item}/${query ? query : '*'}`
      )
      .pipe(
        tap((pluginItemColumns: PluginItemColumn[]) => {
          if (pluginItemColumns) {
            this._pluginItemColumns.next(pluginItemColumns);
          } else {
            this._pluginItemColumns.next([]);
          }
        })
      );
  }
  /**
   * specificRead
   * @param id_pluginItemColumn
   */
  specificRead(id_pluginItemColumn: string): Observable<PluginItemColumn> {
    return this._httpClient
      .get<PluginItemColumn>(this._url + `/specificRead/${id_pluginItemColumn}`)
      .pipe(
        tap((pluginItemColumn: PluginItemColumn) => {
          this._pluginItemColumn.next(pluginItemColumn);
          return pluginItemColumns;
        })
      );
  }
  /**
   * specificReadInLocal
   */
  specificReadInLocal(
    id_pluginItemColumn: string
  ): Observable<PluginItemColumn> {
    return this._pluginItemColumns.pipe(
      take(1),
      map((pluginItemColumns) => {
        /**
         * Find
         */
        const pluginItemColumn =
          pluginItemColumns.find(
            (item) => item.id_plugin_item_column == id_pluginItemColumn
          ) || null;
        /**
         * Update
         */
        this._pluginItemColumn.next(pluginItemColumn!);
        /**
         * Return
         */
        return pluginItemColumn;
      }),
      switchMap((pluginItemColumn) => {
        if (!pluginItemColumn) {
          return throwError(
            () =>
              'No se encontro el elemento con el id ' +
              id_pluginItemColumn +
              '!'
          );
        }
        return of(pluginItemColumn);
      })
    );
  }
  /**
   * update
   * @param pluginItemColumn
   */
  update(pluginItemColumn: PluginItemColumn): Observable<any> {
    return this.pluginItemColumns$.pipe(
      take(1),
      switchMap((pluginItemColumns) =>
        this._httpClient
          .patch(this._url + '/update', pluginItemColumn, {
            headers: this._headers,
          })
          .pipe(
            switchMap((response: any) => {
              /**
               * check the response body to match with the type
               */
              const _pluginItemColumn: PluginItemColumn = response.body;
              /**
               * Find the index of the updated pluginItemColumn
               */
              const index = pluginItemColumns.findIndex(
                (item) =>
                  item.id_plugin_item_column ==
                  pluginItemColumn.id_plugin_item_column
              );
              /**
               * Update the pluginItemColumn
               */
              pluginItemColumns[index] = _pluginItemColumn;
              /**
               * Update the pluginItemColumns
               */
              this._pluginItemColumns.next(pluginItemColumns);

              /**
               * Update the pluginItemColumn
               */
              this._pluginItemColumn.next(_pluginItemColumn);

              return of(_pluginItemColumn);
            })
          )
      )
    );
  }
  /**
   * delete
   * @param id_user_
   * @param id_plugin_item_column
   */
  delete(id_user_: string, id_plugin_item_column: string): Observable<any> {
    return this.pluginItemColumns$.pipe(
      take(1),
      switchMap((pluginItemColumns) =>
        this._httpClient
          .delete(this._url + `/delete`, {
            params: { id_user_, id_plugin_item_column },
          })
          .pipe(
            switchMap((response: any) => {
              if (response && response.body) {
                /**
                 * Find the index of the updated pluginItemColumn
                 */
                const index = pluginItemColumns.findIndex(
                  (item) => item.id_plugin_item_column == id_plugin_item_column
                );
                /**
                 * Delete the object of array
                 */
                pluginItemColumns.splice(index, 1);
                /**
                 * Update the pluginItemColumns
                 */
                this._pluginItemColumns.next(pluginItemColumns);
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
