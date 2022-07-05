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
import { flowVersionLevel, flowVersionLevels } from './flow-version-level.data';
import { FlowVersionLevel } from './flow-version-level.types';

@Injectable({
  providedIn: 'root',
})
export class FlowVersionLevelService {
  private _url: string;
  private _headers: HttpHeaders = new HttpHeaders({
    'Content-Type': 'application/json',
  });

  private _flowVersionLevel: BehaviorSubject<FlowVersionLevel> =
    new BehaviorSubject(flowVersionLevel);
  private _flowVersionLevels: BehaviorSubject<FlowVersionLevel[]> =
    new BehaviorSubject(flowVersionLevels);

  constructor(private _httpClient: HttpClient) {
    this._url = environment.urlBackend + '/app/business/flow_version_level';
  }
  /**
   * Getter
   */
  get flowVersionLevel$(): Observable<FlowVersionLevel> {
    return this._flowVersionLevel.asObservable();
  }
  /**
   * Getter for _flowVersionLevels
   */
  get flowVersionLevels$(): Observable<FlowVersionLevel[]> {
    return this._flowVersionLevels.asObservable();
  }
  /**
   * create
   */
  create(id_user_: string, id_flow_version: string): Observable<any> {
    console.log(id_flow_version);
    return this._flowVersionLevels.pipe(
      take(1),
      switchMap((flowVersionLevels) =>
        this._httpClient
          .post(
            this._url + '/create',
            {
              id_user_: parseInt(id_user_),
              flow_version: {
                id_flow_version: parseInt(id_flow_version),
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
              const _flowVersionLevel: FlowVersionLevel = response.body;
              console.log(_flowVersionLevel);
              /**
               * Update the flowVersionLevel in the store
               */
              this._flowVersionLevels.next([
                _flowVersionLevel,
                ...flowVersionLevels,
              ]);

              return of(_flowVersionLevel);
            })
          )
      )
    );
  }
  /**
   * byFlowVersionRead
   * @param id_flow_version
   */
  byFlowVersionRead(id_flow_version: string): Observable<FlowVersionLevel[]> {
    return this._httpClient
      .get<FlowVersionLevel[]>(
        this._url + `/byFlowVersionRead/${id_flow_version}`
      )
      .pipe(
        tap((flowVersionLevels: FlowVersionLevel[]) => {
          if (flowVersionLevels) {
            this._flowVersionLevels.next(flowVersionLevels);
          } else {
            this._flowVersionLevels.next([]);
          }
        })
      );
  }
  /**
   * byLevelRead
   * @param id_level
   */
  byLevelRead(id_level: string): Observable<FlowVersionLevel[]> {
    return this._httpClient
      .get<FlowVersionLevel[]>(this._url + `/byLevelRead/${id_level}`)
      .pipe(
        tap((flowVersionLevels: FlowVersionLevel[]) => {
          if (flowVersionLevels) {
            this._flowVersionLevels.next(flowVersionLevels);
          } else {
            this._flowVersionLevels.next([]);
          }
        })
      );
  }
  /**
   * specificRead
   * @param id_flowVersionLevel
   */
  specificRead(id_flowVersionLevel: string): Observable<FlowVersionLevel> {
    return this._httpClient
      .get<FlowVersionLevel>(this._url + `/specificRead/${id_flowVersionLevel}`)
      .pipe(
        tap((flowVersionLevel: FlowVersionLevel) => {
          this._flowVersionLevel.next(flowVersionLevel);
          return flowVersionLevels;
        })
      );
  }
  /**
   * specificReadInLocal
   */
  specificReadInLocal(
    id_flowVersionLevel: string
  ): Observable<FlowVersionLevel> {
    return this._flowVersionLevels.pipe(
      take(1),
      map((flowVersionLevels) => {
        /**
         * Find
         */
        const flowVersionLevel =
          flowVersionLevels.find(
            (item) => item.id_flow_version_level == id_flowVersionLevel
          ) || null;
        /**
         * Update
         */
        this._flowVersionLevel.next(flowVersionLevel!);
        /**
         * Return
         */
        return flowVersionLevel;
      }),
      switchMap((flowVersionLevel) => {
        if (!flowVersionLevel) {
          return throwError(
            () =>
              'No se encontro el elemento con el id ' +
              id_flowVersionLevel +
              '!'
          );
        }
        return of(flowVersionLevel);
      })
    );
  }
  /**
   * update
   * @param flowVersionLevel
   */
  update(flowVersionLevel: FlowVersionLevel): Observable<any> {
    return this.flowVersionLevels$.pipe(
      take(1),
      switchMap((flowVersionLevels) =>
        this._httpClient
          .patch(this._url + '/update', flowVersionLevel, {
            headers: this._headers,
          })
          .pipe(
            switchMap((response: any) => {
              /**
               * check the response body to match with the type
               */
              const _flowVersionLevel: FlowVersionLevel = response.body;
              console.log(_flowVersionLevel);
              /**
               * Find the index of the updated flowVersionLevel
               */
              const index = flowVersionLevels.findIndex(
                (item) =>
                  item.id_flow_version_level ==
                  flowVersionLevel.id_flow_version_level
              );
              console.log(index);
              /**
               * Update the flowVersionLevel
               */
              flowVersionLevels[index] = _flowVersionLevel;
              /**
               * Update the flowVersionLevels
               */
              this._flowVersionLevels.next(flowVersionLevels);

              /**
               * Update the flowVersionLevel
               */
              this._flowVersionLevel.next(_flowVersionLevel);

              return of(_flowVersionLevel);
            })
          )
      )
    );
  }
  /**
   * resetFlowVersionLevel
   * @param id_user_
   * @param id_flow_version
   */
  resetFlowVersionLevel(
    id_user_: string,
    id_flow_version: string
  ): Observable<any> {
    return this.flowVersionLevels$.pipe(
      take(1),
      switchMap((flowVersionLevels) =>
        this._httpClient
          .patch(
            this._url + '/reset',
            {
              id_user_: parseInt(id_user_),
              flow_version: {
                id_flow_version: parseInt(id_flow_version),
              },
            },
            {
              headers: this._headers,
            }
          )
          .pipe(
            map((response: any) => {
              if (response.body) {
                this._flowVersionLevels.next([]);
                return true;
              } else {
                this._flowVersionLevels.next(flowVersionLevels);
                return false;
              }
            })
          )
      )
    );
  }
  /**
   * delete
   * @param id_user_
   * @param id_flow_version_level
   */
  delete(id_user_: string, id_flow_version_level: string): Observable<any> {
    return this.flowVersionLevels$.pipe(
      take(1),
      switchMap((flowVersionLevels) =>
        this._httpClient
          .delete(this._url + `/delete`, {
            params: { id_user_, id_flow_version_level },
          })
          .pipe(
            switchMap((response: any) => {
              if (response && response.body) {
                /**
                 * Find the index of the updated flowVersionLevel
                 */
                const index = flowVersionLevels.findIndex(
                  (item) => item.id_flow_version_level == id_flow_version_level
                );
                console.log(index);
                /**
                 * Delete the object of array
                 */
                flowVersionLevels.splice(index, 1);
                /**
                 * Update the flowVersionLevels
                 */
                this._flowVersionLevels.next(flowVersionLevels);
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
