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
import { level, levels } from './level.data';
import { Level } from './level.types';

@Injectable({
  providedIn: 'root',
})
export class LevelService {
  private _url: string;
  private _headers: HttpHeaders = new HttpHeaders({
    'Content-Type': 'application/json',
  });

  private _level: BehaviorSubject<Level> = new BehaviorSubject(level);
  private _levels: BehaviorSubject<Level[]> = new BehaviorSubject(levels);

  constructor(private _httpClient: HttpClient) {
    this._url = environment.urlBackend + '/app/business/level';
  }
  /**
   * Getter
   */
  get level$(): Observable<Level> {
    return this._level.asObservable();
  }
  /**
   * Getter for _levels
   */
  get levels$(): Observable<Level[]> {
    return this._levels.asObservable();
  }
  /**
   * create
   */
  create(
    id_user_: string,
    id_company: string,
    id_template: string
  ): Observable<any> {
    return this._levels.pipe(
      take(1),
      switchMap((levels) =>
        this._httpClient
          .post(
            this._url + '/create',
            {
              id_user_: parseInt(id_user_),
              company: {
                id_company: parseInt(id_company),
              },
              template: {
                id_template: parseInt(id_template),
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
              const _level: Level = response.body;
              /**
               * Update the level in the store
               */
              this._levels.next([_level, ...levels]);

              return of(_level);
            })
          )
      )
    );
  }
  /**
   * queryRead
   * @param query
   */
  queryRead(query: string): Observable<Level[]> {
    return this._httpClient
      .get<Level[]>(this._url + `/queryRead/${query ? query : '*'}`)
      .pipe(
        tap((levels: Level[]) => {
          if (levels) {
            this._levels.next(levels);
          } else {
            this._levels.next([]);
          }
        })
      );
  }
  /**
   * byCompanyQueryRead
   * @param id_company
   * @param query
   */
  byCompanyQueryRead(id_company: string, query: string): Observable<Level[]> {
    return this._httpClient
      .get<Level[]>(
        this._url + `/byCompanyQueryRead/${id_company}/${query ? query : '*'}`
      )
      .pipe(
        tap((levels: Level[]) => {
          if (levels) {
            this._levels.next(levels);
          } else {
            this._levels.next([]);
          }
        })
      );
  }
  /**
   * byTemplateQueryRead
   * @param id_template
   * @param query
   */
  byTemplateQueryRead(id_template: string, query: string): Observable<Level[]> {
    return this._httpClient
      .get<Level[]>(
        this._url + `/byTemplateQueryRead/${id_template}/${query ? query : '*'}`
      )
      .pipe(
        tap((levels: Level[]) => {
          if (levels) {
            this._levels.next(levels);
          } else {
            this._levels.next([]);
          }
        })
      );
  }
  /**
   * byLevelProfileQueryRead
   * @param id_level_profile
   * @param query
   */
  byLevelProfileQueryRead(
    id_level_profile: string,
    query: string
  ): Observable<Level[]> {
    return this._httpClient
      .get<Level[]>(
        this._url +
          `/byLevelProfileQueryRead/${id_level_profile}/${query ? query : '*'}`
      )
      .pipe(
        tap((levels: Level[]) => {
          if (levels) {
            this._levels.next(levels);
          } else {
            this._levels.next([]);
          }
        })
      );
  }
  /**
   * byLevelStatusQueryRead
   * @param id_level_status
   * @param query
   */
  byLevelStatusQueryRead(
    id_level_status: string,
    query: string
  ): Observable<Level[]> {
    return this._httpClient
      .get<Level[]>(
        this._url +
          `/byLevelStatusQueryRead/${id_level_status}/${query ? query : '*'}`
      )
      .pipe(
        tap((levels: Level[]) => {
          if (levels) {
            this._levels.next(levels);
          } else {
            this._levels.next([]);
          }
        })
      );
  }
  /**
   * specificRead
   * @param id_level
   */
  specificRead(id_level: string): Observable<Level> {
    return this._httpClient
      .get<Level>(this._url + `/specificRead/${id_level}`)
      .pipe(
        tap((level: Level) => {
          this._level.next(level);
          return levels;
        })
      );
  }
  /**
   * specificReadInLocal
   */
  specificReadInLocal(id_level: string): Observable<Level> {
    return this._levels.pipe(
      take(1),
      map((levels) => {
        /**
         * Find
         */
        const level = levels.find((item) => item.id_level == id_level) || null;
        /**
         * Update
         */
        this._level.next(level!);
        /**
         * Return
         */
        return level;
      }),
      switchMap((level) => {
        if (!level) {
          return throwError(
            () => 'No se encontro el elemento con el id ' + id_level + '!'
          );
        }
        return of(level);
      })
    );
  }
  /**
   * update
   * @param level
   */
  update(level: Level): Observable<any> {
    return this.levels$.pipe(
      take(1),
      switchMap((levels) =>
        this._httpClient
          .patch(this._url + '/update', level, {
            headers: this._headers,
          })
          .pipe(
            switchMap((response: any) => {
              /**
               * check the response body to match with the type
               */
              const _level: Level = response.body;
              /**
               * Find the index of the updated level
               */
              const index = levels.findIndex(
                (item) => item.id_level == level.id_level
              );
              /**
               * Update the level
               */
              levels[index] = _level;
              /**
               * Update the levels
               */
              this._levels.next(levels);

              /**
               * Update the level
               */
              this._level.next(_level);

              return of(_level);
            })
          )
      )
    );
  }
  /**
   * delete
   * @param id_user_
   * @param id_level
   */
  delete(id_user_: string, id_level: string): Observable<any> {
    return this.levels$.pipe(
      take(1),
      switchMap((levels) =>
        this._httpClient
          .delete(this._url + `/delete`, {
            params: { id_user_, id_level },
          })
          .pipe(
            switchMap((response: any) => {
              if (response && response.body) {
                /**
                 * Find the index of the updated level
                 */
                const index = levels.findIndex(
                  (item) => item.id_level == id_level
                );
                /**
                 * Delete the object of array
                 */
                levels.splice(index, 1);
                /**
                 * Update the levels
                 */
                this._levels.next(levels);
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
