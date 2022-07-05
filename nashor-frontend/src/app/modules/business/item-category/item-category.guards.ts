import { Injectable } from '@angular/core';
import {
  ActivatedRouteSnapshot,
  CanDeactivate,
  RouterStateSnapshot,
  UrlTree,
} from '@angular/router';
import { Observable } from 'rxjs';
import { ItemCategoryDetailsComponent } from './details/details.component';

@Injectable({
  providedIn: 'root',
})
export class CanDeactivateItemCategoryDetails
  implements CanDeactivate<ItemCategoryDetailsComponent>
{
  canDeactivate(
    component: ItemCategoryDetailsComponent,
    currentRoute: ActivatedRouteSnapshot,
    currentState: RouterStateSnapshot,
    nextState: RouterStateSnapshot
  ):
    | Observable<boolean | UrlTree>
    | Promise<boolean | UrlTree>
    | boolean
    | UrlTree {
    /**
     * Get the next route
     */
    let nextRoute: ActivatedRouteSnapshot = nextState.root;
    while (nextRoute.firstChild) {
      nextRoute = nextRoute.firstChild;
    }
    /**
     * If the next state doesn't contain '/item-category'
     * it means we are navigating away from the
     * item_category app
     */
    if (!nextState.url.includes('/item-category')) {
      /**
       * Let it navigate
       */
      return true;
    }
    /**
     * If we are navigating to another
     */
    if (nextRoute.paramMap.get('id_item_category')) {
      /**
       * Just navigate
       */
      return true;
    } else {
      /**
       * Close the drawer first, and then navigate
       */
      return component.closeDrawer().then(() => {
        return true;
      });
    }
  }
}
