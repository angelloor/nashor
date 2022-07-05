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
import { template, templates } from './template.data';
import { Template } from './template.types';

@Injectable({
  providedIn: 'root',
})
export class TemplateService {
  private _url: string;
  private _headers: HttpHeaders = new HttpHeaders({
    'Content-Type': 'application/json',
  });

  private _template: BehaviorSubject<Template> = new BehaviorSubject(template);
  private _templates: BehaviorSubject<Template[]> = new BehaviorSubject(
    templates
  );

  constructor(private _httpClient: HttpClient) {
    this._url = environment.urlBackend + '/app/business/template';
  }
  /**
   * Getter
   */
  get template$(): Observable<Template> {
    return this._template.asObservable();
  }
  /**
   * Getter for _templates
   */
  get templates$(): Observable<Template[]> {
    return this._templates.asObservable();
  }
  /**
   * create
   */
  create(id_user_: string, id_company: string): Observable<any> {
    return this._templates.pipe(
      take(1),
      switchMap((templates) =>
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
              const _template: Template = response.body;
              console.log(_template);
              /**
               * Update the template in the store
               */
              this._templates.next([_template, ...templates]);

              return of(_template);
            })
          )
      )
    );
  }
  /**
   * queryRead
   * @param query
   */
  queryRead(query: string): Observable<Template[]> {
    return this._httpClient
      .get<Template[]>(this._url + `/queryRead/${query ? query : '*'}`)
      .pipe(
        tap((templates: Template[]) => {
          if (templates) {
            this._templates.next(templates);
          } else {
            this._templates.next([]);
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
  ): Observable<Template[]> {
    return this._httpClient
      .get<Template[]>(
        this._url + `/byCompanyQueryRead/${id_company}/${query ? query : '*'}`
      )
      .pipe(
        tap((templates: Template[]) => {
          if (templates) {
            this._templates.next(templates);
          } else {
            this._templates.next([]);
          }
        })
      );
  }
  /**
   * byDocumentationProfileQueryRead
   * @param id_documentation_profile
   * @param query
   */
  byDocumentationProfileQueryRead(
    id_documentation_profile: string,
    query: string
  ): Observable<Template[]> {
    return this._httpClient
      .get<Template[]>(
        this._url +
          `/byDocumentationProfileQueryRead/${id_documentation_profile}/${
            query ? query : '*'
          }`
      )
      .pipe(
        tap((templates: Template[]) => {
          if (templates) {
            this._templates.next(templates);
          } else {
            this._templates.next([]);
          }
        })
      );
  }
  /**
   * specificRead
   * @param id_template
   */
  specificRead(id_template: string): Observable<Template> {
    return this._httpClient
      .get<Template>(this._url + `/specificRead/${id_template}`)
      .pipe(
        tap((template: Template) => {
          this._template.next(template);
          return templates;
        })
      );
  }
  /**
   * specificReadInLocal
   */
  specificReadInLocal(id_template: string): Observable<Template> {
    return this._templates.pipe(
      take(1),
      map((templates) => {
        /**
         * Find
         */
        const template =
          templates.find((item) => item.id_template == id_template) || null;
        /**
         * Update
         */
        this._template.next(template!);
        /**
         * Return
         */
        return template;
      }),
      switchMap((template) => {
        if (!template) {
          return throwError(
            () => 'No se encontro el elemento con el id ' + id_template + '!'
          );
        }
        return of(template);
      })
    );
  }
  /**
   * update
   * @param template
   */
  update(template: Template): Observable<any> {
    return this.templates$.pipe(
      take(1),
      switchMap((templates) =>
        this._httpClient
          .patch(this._url + '/update', template, {
            headers: this._headers,
          })
          .pipe(
            switchMap((response: any) => {
              /**
               * check the response body to match with the type
               */
              const _template: Template = response.body;
              console.log(_template);
              /**
               * Find the index of the updated template
               */
              const index = templates.findIndex(
                (item) => item.id_template == template.id_template
              );
              console.log(index);
              /**
               * Update the template
               */
              templates[index] = _template;
              /**
               * Update the templates
               */
              this._templates.next(templates);

              /**
               * Update the template
               */
              this._template.next(_template);

              return of(_template);
            })
          )
      )
    );
  }
  /**
   * delete
   * @param id_user_
   * @param id_template
   */
  delete(id_user_: string, id_template: string): Observable<any> {
    return this.templates$.pipe(
      take(1),
      switchMap((templates) =>
        this._httpClient
          .delete(this._url + `/delete`, {
            params: { id_user_, id_template },
          })
          .pipe(
            switchMap((response: any) => {
              if (response && response.body) {
                /**
                 * Find the index of the updated template
                 */
                const index = templates.findIndex(
                  (item) => item.id_template == id_template
                );
                console.log(index);
                /**
                 * Delete the object of array
                 */
                templates.splice(index, 1);
                /**
                 * Update the templates
                 */
                this._templates.next(templates);
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
