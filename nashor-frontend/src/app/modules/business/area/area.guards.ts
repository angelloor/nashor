import { Injectable } from '@angular/core';
import {
  ActivatedRouteSnapshot,
  CanDeactivate,
  RouterStateSnapshot,
  UrlTree,
} from '@angular/router';
import { Observable } from 'rxjs';
import { AreaDetailsComponent } from './details/details.component';

@Injectable({
  providedIn: 'root',
})
export class CanDeactivateAreaDetails
  implements CanDeactivate<AreaDetailsComponent>
{
  canDeactivate(
    component: AreaDetailsComponent,
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
     * If the next state doesn't contain '/area'
     * it means we are navigating away from the
     * area app
     */
    if (!nextState.url.includes('/area')) {
      /**
       * Let it navigate
       */
      return true;
    }
    /**
     * If we are navigating to another
     */
    if (nextRoute.paramMap.get('id_area')) {
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
