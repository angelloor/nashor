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
import { pluginItem, pluginItems } from './plugin-item.data';
import { PluginItem } from './plugin-item.types';

@Injectable({
  providedIn: 'root',
})
export class PluginItemService {
  private _url: string;
  private _headers: HttpHeaders = new HttpHeaders({
    'Content-Type': 'application/json',
  });

  private _pluginItem: BehaviorSubject<PluginItem> = new BehaviorSubject(
    pluginItem
  );
  private _pluginItems: BehaviorSubject<PluginItem[]> = new BehaviorSubject(
    pluginItems
  );

  constructor(private _httpClient: HttpClient) {
    this._url = environment.urlBackend + '/app/business/plugin_item';
  }
  /**
   * Getter
   */
  get pluginItem$(): Observable<PluginItem> {
    return this._pluginItem.asObservable();
  }
  /**
   * Getter for _pluginItems
   */
  get pluginItems$(): Observable<PluginItem[]> {
    return this._pluginItems.asObservable();
  }
  /**
   * create
   */
  create(id_user_: string, id_company: string): Observable<any> {
    return this._pluginItems.pipe(
      take(1),
      switchMap((pluginItems) =>
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
              const _pluginItem: PluginItem = response.body;
              console.log(_pluginItem);
              /**
               * Update the pluginItem in the store
               */
              this._pluginItems.next([_pluginItem, ...pluginItems]);

              return of(_pluginItem);
            })
          )
      )
    );
  }
  /**
   * queryRead
   * @param query
   */
  queryRead(query: string): Observable<PluginItem[]> {
    return this._httpClient
      .get<PluginItem[]>(this._url + `/queryRead/${query ? query : '*'}`)
      .pipe(
        tap((pluginItems: PluginItem[]) => {
          if (pluginItems) {
            this._pluginItems.next(pluginItems);
          } else {
            this._pluginItems.next([]);
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
  ): Observable<PluginItem[]> {
    return this._httpClient
      .get<PluginItem[]>(
        this._url + `/byCompanyQueryRead/${id_company}/${query ? query : '*'}`
      )
      .pipe(
        tap((pluginItems: PluginItem[]) => {
          if (pluginItems) {
            this._pluginItems.next(pluginItems);
          } else {
            this._pluginItems.next([]);
          }
        })
      );
  }
  /**
   * specificRead
   * @param id_pluginItem
   */
  specificRead(id_pluginItem: string): Observable<PluginItem> {
    return this._httpClient
      .get<PluginItem>(this._url + `/specificRead/${id_pluginItem}`)
      .pipe(
        tap((pluginItem: PluginItem) => {
          this._pluginItem.next(pluginItem);
          return pluginItems;
        })
      );
  }
  /**
   * specificReadInLocal
   */
  specificReadInLocal(id_pluginItem: string): Observable<PluginItem> {
    return this._pluginItems.pipe(
      take(1),
      map((pluginItems) => {
        /**
         * Find
         */
        const pluginItem =
          pluginItems.find((item) => item.id_plugin_item == id_pluginItem) ||
          null;
        /**
         * Update
         */
        this._pluginItem.next(pluginItem!);
        /**
         * Return
         */
        return pluginItem;
      }),
      switchMap((pluginItem) => {
        if (!pluginItem) {
          return throwError(
            () => 'No se encontro el elemento con el id ' + id_pluginItem + '!'
          );
        }
        return of(pluginItem);
      })
    );
  }
  /**
   * update
   * @param pluginItem
   */
  update(pluginItem: PluginItem): Observable<any> {
    return this.pluginItems$.pipe(
      take(1),
      switchMap((pluginItems) =>
        this._httpClient
          .patch(this._url + '/update', pluginItem, {
            headers: this._headers,
          })
          .pipe(
            switchMap((response: any) => {
              /**
               * check the response body to match with the type
               */
              const _pluginItem: PluginItem = response.body;
              console.log(_pluginItem);
              /**
               * Find the index of the updated pluginItem
               */
              const index = pluginItems.findIndex(
                (item) => item.id_plugin_item == pluginItem.id_plugin_item
              );
              console.log(index);
              /**
               * Update the pluginItem
               */
              pluginItems[index] = _pluginItem;
              /**
               * Update the pluginItems
               */
              this._pluginItems.next(pluginItems);

              /**
               * Update the pluginItem
               */
              this._pluginItem.next(_pluginItem);

              return of(_pluginItem);
            })
          )
      )
    );
  }
  /**
   * delete
   * @param id_user_
   * @param id_plugin_item
   */
  delete(id_user_: string, id_plugin_item: string): Observable<any> {
    return this.pluginItems$.pipe(
      take(1),
      switchMap((pluginItems) =>
        this._httpClient
          .delete(this._url + `/delete`, {
            params: { id_user_, id_plugin_item },
          })
          .pipe(
            switchMap((response: any) => {
              if (response && response.body) {
                /**
                 * Find the index of the updated pluginItem
                 */
                const index = pluginItems.findIndex(
                  (item) => item.id_plugin_item == id_plugin_item
                );
                console.log(index);
                /**
                 * Delete the object of array
                 */
                pluginItems.splice(index, 1);
                /**
                 * Update the pluginItems
                 */
                this._pluginItems.next(pluginItems);
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
