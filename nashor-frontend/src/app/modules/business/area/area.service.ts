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
import { area, areas } from './area.data';
import { Area } from './area.types';

@Injectable({
  providedIn: 'root',
})
export class AreaService {
  private _url: string;
  private _headers: HttpHeaders = new HttpHeaders({
    'Content-Type': 'application/json',
  });

  private _area: BehaviorSubject<Area> = new BehaviorSubject(area);
  private _areas: BehaviorSubject<Area[]> = new BehaviorSubject(areas);

  constructor(private _httpClient: HttpClient) {
    this._url = environment.urlBackend + '/app/business/area';
  }
  /**
   * Getter
   */
  get area$(): Observable<Area> {
    return this._area.asObservable();
  }
  /**
   * Getter for _areas
   */
  get areas$(): Observable<Area[]> {
    return this._areas.asObservable();
  }
  /**
   * create
   */
  create(id_user_: string, id_company: string): Observable<any> {
    return this._areas.pipe(
      take(1),
      switchMap((areas) =>
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
              const _area: Area = response.body;
              console.log(_area);
              /**
               * Update the area in the store
               */
              this._areas.next([_area, ...areas]);

              return of(_area);
            })
          )
      )
    );
  }
  /**
   * queryRead
   * @param query
   */
  queryRead(query: string): Observable<Area[]> {
    return this._httpClient
      .get<Area[]>(this._url + `/queryRead/${query ? query : '*'}`)
      .pipe(
        tap((areas: Area[]) => {
          if (areas) {
            this._areas.next(areas);
          } else {
            this._areas.next([]);
          }
        })
      );
  }
  /**
   * byCompanyQueryRead
   * @param id_company
   * @param query
   */
  byCompanyQueryRead(id_company: string, query: string): Observable<Area[]> {
    return this._httpClient
      .get<Area[]>(
        this._url + `/byCompanyQueryRead/${id_company}/${query ? query : '*'}`
      )
      .pipe(
        tap((areas: Area[]) => {
          if (areas) {
            this._areas.next(areas);
          } else {
            this._areas.next([]);
          }
        })
      );
  }
  /**
   * specificRead
   * @param id_area
   */
  specificRead(id_area: string): Observable<Area> {
    return this._httpClient
      .get<Area>(this._url + `/specificRead/${id_area}`)
      .pipe(
        tap((area: Area) => {
          this._area.next(area);
          return areas;
        })
      );
  }
  /**
   * specificReadInLocal
   */
  specificReadInLocal(id_area: string): Observable<Area> {
    return this._areas.pipe(
      take(1),
      map((areas) => {
        /**
         * Find
         */
        const area = areas.find((item) => item.id_area == id_area) || null;
        /**
         * Update
         */
        this._area.next(area!);
        /**
         * Return
         */
        return area;
      }),
      switchMap((area) => {
        if (!area) {
          return throwError(
            () => 'No se encontro el elemento con el id ' + id_area + '!'
          );
        }
        return of(area);
      })
    );
  }
  /**
   * update
   * @param area
   */
  update(area: Area): Observable<any> {
    return this.areas$.pipe(
      take(1),
      switchMap((areas) =>
        this._httpClient
          .patch(this._url + '/update', area, {
            headers: this._headers,
          })
          .pipe(
            switchMap((response: any) => {
              /**
               * check the response body to match with the type
               */
              const _area: Area = response.body;
              console.log(_area);
              /**
               * Find the index of the updated area
               */
              const index = areas.findIndex(
                (item) => item.id_area == area.id_area
              );
              console.log(index);
              /**
               * Update the area
               */
              areas[index] = _area;
              /**
               * Update the areas
               */
              this._areas.next(areas);

              /**
               * Update the area
               */
              this._area.next(_area);

              return of(_area);
            })
          )
      )
    );
  }
  /**
   * delete
   * @param id_user_
   * @param id_area
   */
  delete(id_user_: string, id_area: string): Observable<any> {
    return this.areas$.pipe(
      take(1),
      switchMap((areas) =>
        this._httpClient
          .delete(this._url + `/delete`, {
            params: { id_user_, id_area },
          })
          .pipe(
            switchMap((response: any) => {
              if (response && response.body) {
                /**
                 * Find the index of the updated area
                 */
                const index = areas.findIndex(
                  (item) => item.id_area == id_area
                );
                console.log(index);
                /**
                 * Delete the object of array
                 */
                areas.splice(index, 1);
                /**
                 * Update the areas
                 */
                this._areas.next(areas);
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
