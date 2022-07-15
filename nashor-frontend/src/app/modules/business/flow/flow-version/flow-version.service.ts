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
import { flowVersion, flowVersions } from './flow-version.data';
import { FlowVersion } from './flow-version.types';

@Injectable({
  providedIn: 'root',
})
export class FlowVersionService {
  private _url: string;
  private _headers: HttpHeaders = new HttpHeaders({
    'Content-Type': 'application/json',
  });

  private _flowVersion: BehaviorSubject<FlowVersion> = new BehaviorSubject(
    flowVersion
  );
  private _flowVersions: BehaviorSubject<FlowVersion[]> = new BehaviorSubject(
    flowVersions
  );

  constructor(private _httpClient: HttpClient) {
    this._url = environment.urlBackend + '/app/business/flow_version';
  }
  /**
   * Getter
   */
  get flowVersion$(): Observable<FlowVersion> {
    return this._flowVersion.asObservable();
  }
  /**
   * Setter
   */
  set $flowVersion(flow_version: FlowVersion) {
    this._flowVersion.next(flow_version);
  }
  /**
   * Getter for _flowVersions
   */
  get flowVersions$(): Observable<FlowVersion[]> {
    return this._flowVersions.asObservable();
  }
  /**
   * create
   */
  create(id_user_: string, id_flow: string): Observable<any> {
    return this._flowVersions.pipe(
      take(1),
      switchMap((flowVersions) =>
        this._httpClient
          .post(
            this._url + '/create',
            {
              id_user_: parseInt(id_user_),
              flow: {
                id_flow: parseInt(id_flow),
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
              const _flowVersion: FlowVersion = response.body;
              /**
               * Update the flowVersion in the store
               */
              this._flowVersions.next([_flowVersion, ...flowVersions]);

              return of(_flowVersion);
            })
          )
      )
    );
  }
  /**
   * byFlowRead
   * @param id_flow
   */
  byFlowRead(id_flow: string): Observable<FlowVersion[]> {
    return this._httpClient
      .get<FlowVersion[]>(this._url + `/byFlowRead/${id_flow}`)
      .pipe(
        tap((flowVersions: FlowVersion[]) => {
          if (flowVersions) {
            this._flowVersions.next(flowVersions);
          } else {
            this._flowVersions.next([]);
          }
        })
      );
  }
  /**
   * specificRead
   * @param id_flowVersion
   */
  specificRead(id_flowVersion: string): Observable<FlowVersion> {
    return this._httpClient
      .get<FlowVersion>(this._url + `/specificRead/${id_flowVersion}`)
      .pipe(
        tap((flowVersion: FlowVersion) => {
          this._flowVersion.next(flowVersion);
          return flowVersions;
        })
      );
  }
  /**
   * specificReadInLocal
   */
  specificReadInLocal(id_flowVersion: string): Observable<FlowVersion> {
    return this._flowVersions.pipe(
      take(1),
      map((flowVersions) => {
        /**
         * Find
         */
        const flowVersion =
          flowVersions.find((item) => item.id_flow_version == id_flowVersion) ||
          null;
        /**
         * Update
         */
        this._flowVersion.next(flowVersion!);
        /**
         * Return
         */
        return flowVersion;
      }),
      switchMap((flowVersion) => {
        if (!flowVersion) {
          return throwError(
            () => 'No se encontro el elemento con el id ' + id_flowVersion + '!'
          );
        }
        return of(flowVersion);
      })
    );
  }
  /**
   * update
   * @param flowVersion
   */
  update(flowVersion: FlowVersion): Observable<any> {
    return this.flowVersions$.pipe(
      take(1),
      switchMap((flowVersions) =>
        this._httpClient
          .patch(this._url + '/update', flowVersion, {
            headers: this._headers,
          })
          .pipe(
            switchMap((response: any) => {
              /**
               * check the response body to match with the type
               */
              const _flowVersion: FlowVersion = response.body;
              /**
               * Find the index of the updated flowVersion
               */
              const index = flowVersions.findIndex(
                (item) => item.id_flow_version == flowVersion.id_flow_version
              );
              /**
               * Update the flowVersion
               */
              flowVersions[index] = _flowVersion;
              /**
               * Update the flowVersions
               */
              this._flowVersions.next(flowVersions);

              /**
               * Update the flowVersion
               */
              this._flowVersion.next(_flowVersion);

              return of(_flowVersion);
            })
          )
      )
    );
  }
  /**
   * delete
   * @param id_user_
   * @param id_flow_version
   */
  delete(id_user_: string, id_flow_version: string): Observable<any> {
    return this.flowVersions$.pipe(
      take(1),
      switchMap((flowVersions) =>
        this._httpClient
          .delete(this._url + `/delete`, {
            params: { id_user_, id_flow_version },
          })
          .pipe(
            switchMap((response: any) => {
              if (response && response.body) {
                /**
                 * Find the index of the updated flowVersion
                 */
                const index = flowVersions.findIndex(
                  (item) => item.id_flow_version == id_flow_version
                );
                /**
                 * Delete the object of array
                 */
                flowVersions.splice(index, 1);
                /**
                 * Update the flowVersions
                 */
                this._flowVersions.next(flowVersions);
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
