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
import { templateControl, templateControls } from './template-control.data';
import { TemplateControl } from './template-control.types';

@Injectable({
  providedIn: 'root',
})
export class TemplateControlService {
  private _url: string;
  private _headers: HttpHeaders = new HttpHeaders({
    'Content-Type': 'application/json',
  });

  private _templateControl: BehaviorSubject<TemplateControl> =
    new BehaviorSubject(templateControl);
  private _templateControls: BehaviorSubject<TemplateControl[]> =
    new BehaviorSubject(templateControls);

  constructor(private _httpClient: HttpClient) {
    this._url = environment.urlBackend + '/app/business/template_control';
  }
  /**
   * Getter
   */
  get templateControl$(): Observable<TemplateControl> {
    return this._templateControl.asObservable();
  }
  /**
   * Getter for _templateControls
   */
  get templateControls$(): Observable<TemplateControl[]> {
    return this._templateControls.asObservable();
  }
  /**
   * create
   */
  create(
    id_user_: string,
    id_template: string,
    id_control: string
  ): Observable<any> {
    return this._templateControls.pipe(
      take(1),
      switchMap((templateControls) =>
        this._httpClient
          .post(
            this._url + '/create',
            {
              id_user_: parseInt(id_user_),
              template: {
                id_template: parseInt(id_template),
              },
              control: {
                id_control: parseInt(id_control),
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
              const _templateControl: TemplateControl = response.body;
              /**
               * Update the templateControl in the store
               */
              this._templateControls.next([
                _templateControl,
                ...templateControls,
              ]);

              return of(_templateControl);
            })
          )
      )
    );
  }
  /**
   * createWithNewControl
   */
  createWithNewControl(id_user_: string, id_template: string): Observable<any> {
    return this._templateControls.pipe(
      take(1),
      switchMap((templateControls) =>
        this._httpClient
          .post(
            this._url + '/createWithNewControl',
            {
              id_user_: parseInt(id_user_),
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
              const _templateControl: TemplateControl = response.body;
              /**
               * Update the templateControl in the store
               */
              this._templateControls.next([
                ...templateControls,
                _templateControl,
              ]);

              return of(_templateControl);
            })
          )
      )
    );
  }
  /**
   * byTemplateRead
   * @param _id_template
   */
  byTemplateRead(_id_template: string): Observable<TemplateControl[]> {
    return this._httpClient
      .get<TemplateControl[]>(this._url + `/byTemplateRead/${_id_template}`)
      .pipe(
        tap((templateControls: TemplateControl[]) => {
          if (templateControls) {
            this._templateControls.next(templateControls);
          } else {
            this._templateControls.next([]);
          }
        })
      );
  }
  /**
   * byControlRead
   * @param id_control
   */
  byControlRead(id_control: string): Observable<TemplateControl[]> {
    return this._httpClient
      .get<TemplateControl[]>(this._url + `/byControlRead/${id_control}`)
      .pipe(
        tap((templateControls: TemplateControl[]) => {
          if (templateControls) {
            this._templateControls.next(templateControls);
          } else {
            this._templateControls.next([]);
          }
        })
      );
  }
  /**
   * specificRead
   * @param id_templateControl
   */
  specificRead(id_templateControl: string): Observable<TemplateControl> {
    return this._httpClient
      .get<TemplateControl>(this._url + `/specificRead/${id_templateControl}`)
      .pipe(
        tap((templateControl: TemplateControl) => {
          this._templateControl.next(templateControl);
          return templateControls;
        })
      );
  }
  /**
   * specificReadInLocal
   */
  specificReadInLocal(id_templateControl: string): Observable<TemplateControl> {
    return this._templateControls.pipe(
      take(1),
      map((templateControls) => {
        /**
         * Find
         */
        const templateControl =
          templateControls.find(
            (item) => item.id_template_control == id_templateControl
          ) || null;
        /**
         * Update
         */
        this._templateControl.next(templateControl!);
        /**
         * Return
         */
        return templateControl;
      }),
      switchMap((templateControl) => {
        if (!templateControl) {
          return throwError(
            () =>
              'No se encontro el elemento con el id ' + id_templateControl + '!'
          );
        }
        return of(templateControl);
      })
    );
  }
  /**
   * updatePositions
   * @param id_user_ that will be updated
   * @param templateControl[]
   */
  updatePositions(
    id_user_: string,
    id_template: string,
    templateControl: TemplateControl[]
  ): Observable<TemplateControl[]> {
    return this._httpClient
      .patch(
        this._url + '/updatePositions',
        {
          id_user_: parseInt(id_user_),
          template: {
            id_template: parseInt(id_template),
          },
          template_control: templateControl,
        },
        {
          headers: this._headers,
        }
      )
      .pipe(
        switchMap((response: TemplateControl[] | any) => {
          /**
           * Update the templateControls
           */
          console.log(response.body);
          this._templateControls.next(response.body);

          return of(response.body);
        })
      );
  }
  /**
   * updateTemplateControlProperties
   * @param templateControl
   */
  updateTemplateControlProperties(
    templateControl: TemplateControl
  ): Observable<any> {
    return this.templateControls$.pipe(
      take(1),
      switchMap((templateControls) =>
        this._httpClient
          .patch(this._url + '/updateControlProperties', templateControl, {
            headers: this._headers,
          })
          .pipe(
            switchMap((response: any) => {
              /**
               * check the response body to match with the type
               */
              const _templateControl: TemplateControl = response.body;
              /**
               * Find the index of the updated templateControl
               */
              const index = templateControls.findIndex(
                (item) =>
                  item.id_template_control ==
                  templateControl.id_template_control
              );
              /**
               * Update the templateControl
               */
              templateControls[index] = _templateControl;
              /**
               * Update the templateControls
               */
              this._templateControls.next(templateControls);

              /**
               * Update the templateControl
               */
              this._templateControl.next(_templateControl);

              return of(_templateControl);
            })
          )
      )
    );
  }
  /**
   * deleteTemplateControlByControl
   */
  deleteTemplateControlByControl(id_control: string) {
    return this.templateControls$.pipe(
      take(1),
      switchMap((templateControls: TemplateControl[]) => {
        templateControls.map((item, index) => {
          if (item.control.id_control == id_control) {
            templateControls.splice(index, 1);
          }
        });
        /**
         * Update the templateControls
         */
        this._templateControls.next(templateControls);
        return of(true);
      })
    );
  }
  /**
   * delete
   * @param id_user_
   * @param id_template_control
   */
  delete(id_user_: string, id_template_control: string): Observable<any> {
    return this.templateControls$.pipe(
      take(1),
      switchMap((templateControls) =>
        this._httpClient
          .delete(this._url + `/delete`, {
            params: { id_user_, id_template_control },
          })
          .pipe(
            switchMap((response: any) => {
              if (response && response.body) {
                /**
                 * Find the index of the updated templateControl
                 */
                const index = templateControls.findIndex(
                  (item) => item.id_template_control == id_template_control
                );
                /**
                 * Delete the object of array
                 */
                templateControls.splice(index, 1);
                /**
                 * Update the templateControls
                 */
                this._templateControls.next(templateControls);
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
