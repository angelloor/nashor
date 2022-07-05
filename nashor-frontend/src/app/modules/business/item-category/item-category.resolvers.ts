import { Injectable } from '@angular/core';
import {
  ActivatedRouteSnapshot,
  Resolve,
  Router,
  RouterStateSnapshot,
} from '@angular/router';
import { Observable, throwError } from 'rxjs';
import { catchError } from 'rxjs/operators';
import { ItemCategoryService } from './item-category.service';
import { ItemCategory } from './item-category.types';

@Injectable({
  providedIn: 'root',
})
export class ItemCategoryResolver implements Resolve<any> {
  /**
   * Constructor
   */
  constructor(
    private _itemCategoryService: ItemCategoryService,
    private _router: Router
  ) {}

  /** ----------------------------------------------------------------------------------------------------- */
  /** @ Public methods
   /** ----------------------------------------------------------------------------------------------------- */

  /**
   * Resolver
   * @param route
   * @param state
   */
  resolve(
    route: ActivatedRouteSnapshot,
    state: RouterStateSnapshot
  ): Observable<ItemCategory> {
    return this._itemCategoryService
      .specificReadInLocal(route.paramMap.get('id_item_category')!)
      .pipe(
        /**
         * Error here means the requested is not available
         */
        catchError((error) => {
          /**
           * Log the error
           */
          // console.error(error);
          /**
           * Get the parent url
           */
          const parentUrl = state.url.split('/').slice(0, -1).join('/');
          /**
           * Navigate to there
           */
          this._router.navigateByUrl(parentUrl);
          /**
           * Throw an error
           */
          return throwError(() => error);
        })
      );
  }
}
