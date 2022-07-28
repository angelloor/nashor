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
import { flow, flows } from './flow.data';
import { Flow } from './flow.types';

@Injectable({
  providedIn: 'root',
})
export class FlowService {
  private _url: string;
  private _headers: HttpHeaders = new HttpHeaders({
    'Content-Type': 'application/json',
  });

  private _flow: BehaviorSubject<Flow> = new BehaviorSubject(flow);
  private _flows: BehaviorSubject<Flow[]> = new BehaviorSubject(flows);

  constructor(private _httpClient: HttpClient) {
    this._url = environment.urlBackend + '/app/business/flow';
  }
  /**
   * Getter
   */
  get flow$(): Observable<Flow> {
    return this._flow.asObservable();
  }
  /**
   * Getter for _flows
   */
  get flows$(): Observable<Flow[]> {
    return this._flows.asObservable();
  }
  /**
   * create
   */
  create(id_user_: string, id_company: string): Observable<any> {
    return this._flows.pipe(
      take(1),
      switchMap((flows) =>
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
              const _flow: Flow = response.body;
              /**
               * Update the flow in the store
               */
              this._flows.next([_flow, ...flows]);

              return of(_flow);
            })
          )
      )
    );
  }
  /**
   * queryRead
   * @param query
   */
  queryRead(query: string): Observable<Flow[]> {
    return this._httpClient
      .get<Flow[]>(this._url + `/queryRead/${query ? query : '*'}`)
      .pipe(
        tap((flows: Flow[]) => {
          if (flows) {
            this._flows.next(flows);
          } else {
            this._flows.next([]);
          }
        })
      );
  }
  /**
   * byCompanyQueryRead
   * @param id_company
   * @param query
   */
  byCompanyQueryRead(id_company: string, query: string): Observable<Flow[]> {
    return this._httpClient
      .get<Flow[]>(
        this._url + `/byCompanyQueryRead/${id_company}/${query ? query : '*'}`
      )
      .pipe(
        tap((flows: Flow[]) => {
          if (flows) {
            this._flows.next(flows);
          } else {
            this._flows.next([]);
          }
        })
      );
  }
  /**
   * specificRead
   * @param id_flow
   */
  specificRead(id_flow: string): Observable<Flow> {
    return this._httpClient
      .get<Flow>(this._url + `/specificRead/${id_flow}`)
      .pipe(
        tap((flow: Flow) => {
          this._flow.next(flow);
          return flows;
        })
      );
  }
  /**
   * specificReadInLocal
   */
  specificReadInLocal(id_flow: string): Observable<Flow> {
    return this._flows.pipe(
      take(1),
      map((flows) => {
        /**
         * Find
         */
        const flow = flows.find((item) => item.id_flow == id_flow) || null;
        /**
         * Update
         */
        this._flow.next(flow!);
        /**
         * Return
         */
        return flow;
      }),
      switchMap((flow) => {
        if (!flow) {
          return throwError(
            () => 'No se encontro el elemento con el id ' + id_flow + '!'
          );
        }
        return of(flow);
      })
    );
  }
  /**
   * update
   * @param flow
   */
  update(flow: Flow): Observable<any> {
    return this.flows$.pipe(
      take(1),
      switchMap((flows) =>
        this._httpClient
          .patch(this._url + '/update', flow, {
            headers: this._headers,
          })
          .pipe(
            switchMap((response: any) => {
              /**
               * check the response body to match with the type
               */
              const _flow: Flow = response.body;
              /**
               * Find the index of the updated flow
               */
              const index = flows.findIndex(
                (item) => item.id_flow == flow.id_flow
              );
              /**
               * Update the flow
               */
              flows[index] = _flow;
              /**
               * Update the flows
               */
              this._flows.next(flows);

              /**
               * Update the flow
               */
              this._flow.next(_flow);

              return of(_flow);
            })
          )
      )
    );
  }
  /**
   * delete
   * @param id_user_
   * @param id_flow
   */
  delete(id_user_: string, id_flow: string): Observable<any> {
    return this.flows$.pipe(
      take(1),
      switchMap((flows) =>
        this._httpClient
          .delete(this._url + `/delete`, {
            params: { id_user_, id_flow },
          })
          .pipe(
            switchMap((response: any) => {
              if (response && response.body) {
                /**
                 * Find the index of the updated flow
                 */
                const index = flows.findIndex(
                  (item) => item.id_flow == id_flow
                );
                /**
                 * Delete the object of array
                 */
                flows.splice(index, 1);
                /**
                 * Update the flows
                 */
                this._flows.next(flows);
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
