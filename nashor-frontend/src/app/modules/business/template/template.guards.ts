import { Injectable } from '@angular/core';
import {
  ActivatedRouteSnapshot,
  CanDeactivate,
  RouterStateSnapshot,
  UrlTree,
} from '@angular/router';
import { Observable } from 'rxjs';
import { TemplateDetailsComponent } from './details/details.component';

@Injectable({
  providedIn: 'root',
})
export class CanDeactivateTemplateDetails
  implements CanDeactivate<TemplateDetailsComponent>
{
  canDeactivate(
    component: TemplateDetailsComponent,
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
     * If the next state doesn't contain '/template'
     * it means we are navigating away from the
     * template app
     */
    if (!nextState.url.includes('/template')) {
      /**
       * Let it navigate
       */
      return true;
    }
    /**
     * If we are navigating to another
     */
    if (nextRoute.paramMap.get('id_template')) {
      /**
       * Just navigate
       */
      return true;
    } else {
      return true;
    }
  }
}
