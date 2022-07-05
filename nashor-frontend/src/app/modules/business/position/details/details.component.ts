import { angelAnimations } from '@angel/animations';
import { AngelAlertType } from '@angel/components/alert';
import {
  ActionAngelConfirmation,
  AngelConfirmationService,
} from '@angel/services/confirmation';
import { OverlayRef } from '@angular/cdk/overlay';
import { DOCUMENT } from '@angular/common';
import { ChangeDetectorRef, Component, Inject, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { MatDrawerToggleResult } from '@angular/material/sidenav';
import { ActivatedRoute, Router } from '@angular/router';
import { Store } from '@ngrx/store';
import { AppInitialData, MessageAPI } from 'app/core/app/app.type';
import { LayoutService } from 'app/layout/layout.service';
import { CompanyService } from 'app/modules/core/company/company.service';
import { NotificationService } from 'app/shared/notification/notification.service';
import { filter, fromEvent, merge, Subject, takeUntil } from 'rxjs';
import { PositionListComponent } from '../list/list.component';
import { PositionService } from '../position.service';
import { Position } from '../position.types';

@Component({
  selector: 'position-details',
  templateUrl: './details.component.html',
  animations: angelAnimations,
})
export class PositionDetailsComponent implements OnInit {
  nameEntity: string = 'Cargo';
  private data!: AppInitialData;

  editMode: boolean = false;
  /**
   * Alert
   */
  alert: { type: AngelAlertType; message: string } = {
    type: 'error',
    message: '',
  };
  showAlert: boolean = false;
  /**
   * Alert
   */
  position!: Position;
  positionForm!: FormGroup;
  private positions!: Position[];

  private _tagsPanelOverlayRef!: OverlayRef;
  private _unsubscribeAll: Subject<any> = new Subject<any>();
  /**
   * isOpenModal
   */
  isOpenModal: boolean = false;
  /**
   * isOpenModal
   */
  /**
   * Constructor
   */
  constructor(
    private _store: Store<{ global: AppInitialData }>,
    private _changeDetectorRef: ChangeDetectorRef,
    private _positionListComponent: PositionListComponent,
    private _positionService: PositionService,
    @Inject(DOCUMENT) private _document: any,
    private _formBuilder: FormBuilder,
    private _activatedRoute: ActivatedRoute,
    private _router: Router,
    private _notificationService: NotificationService,
    private _angelConfirmationService: AngelConfirmationService,
    private _layoutService: LayoutService,
    private _companyService: CompanyService
  ) {}

  /** ----------------------------------------------------------------------------------------------------- */
  /** @ Lifecycle hooks
	  /** ----------------------------------------------------------------------------------------------------- */

  /**
   * On init
   */
  ngOnInit(): void {
    /**
     * isOpenModal
     */
    this._layoutService.isOpenModal$
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((_isOpenModal: boolean) => {
        this.isOpenModal = _isOpenModal;
      });
    /**
     * isOpenModal
     */
    /**
     * Subscribe to user changes of state
     */
    this._store.pipe(takeUntil(this._unsubscribeAll)).subscribe((state) => {
      this.data = state.global;
    });
    /**
     * Open the drawer
     */
    this._positionListComponent.matDrawer.open();
    /**
     * Create the position form
     */
    this.positionForm = this._formBuilder.group({
      id_position: [''],
      id_company: ['', [Validators.required]],
      name_position: ['', [Validators.required, Validators.maxLength(100)]],
      description_position: [
        '',
        [Validators.required, Validators.maxLength(250)],
      ],
    });
    /**
     * Get the positions
     */
    this._positionService.positions$
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((positions: Position[]) => {
        this.positions = positions;
        /**
         * Mark for check
         */
        this._changeDetectorRef.markForCheck();
      });
    /**
     * Get the position
     */
    this._positionService.position$
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((position: Position) => {
        /**
         * Open the drawer in case it is closed
         */
        this._positionListComponent.matDrawer.open();
        /**
         * Get the position
         */
        this.position = position;

        /**
         * Patch values to the form
         */
        this.patchForm();
        /**
         * Toggle the edit mode off
         */
        this.toggleEditMode(false);
        /**
         * Mark for check
         */
        this._changeDetectorRef.markForCheck();
      });
    /**
     * Shortcuts
     */
    merge(
      fromEvent(this._document, 'keydown').pipe(
        takeUntil(this._unsubscribeAll),
        filter<KeyboardEvent | any>((e) => e.key === 'Escape')
      )
    )
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((keyUpOrKeyDown) => {
        console.log(keyUpOrKeyDown);
        /**
         * Shortcut Escape
         */
        if (!this.isOpenModal && keyUpOrKeyDown.key == 'Escape') {
          /**
           * Navigate parentUrl
           */
          const parentUrl = this._router.url.split('/').slice(0, -1).join('/');
          this._router.navigate([parentUrl]);
          /**
           * Close Drawer
           */
          this.closeDrawer();
        }
      });
    /**
     * Shortcuts
     */
  }
  /**
   * Pacth the form with the information of the database
   */
  patchForm(): void {
    this.positionForm.patchValue({
      ...this.position,
      id_company: this.position.company.id_company,
    });
  }
  /**
   * On destroy
   */
  ngOnDestroy(): void {
    /**
     * Unsubscribe from all subscriptions
     */
    this._unsubscribeAll.next(0);
    this._unsubscribeAll.complete();
    /**
     * Dispose the overlays if they are still on the DOM
     */
    if (this._tagsPanelOverlayRef) {
      this._tagsPanelOverlayRef.dispose();
    }
  }

  /** ----------------------------------------------------------------------------------------------------- */
  /** @ Public methods
	  /** ----------------------------------------------------------------------------------------------------- */

  /**
   * Close the drawer
   */
  closeDrawer(): Promise<MatDrawerToggleResult> {
    return this._positionListComponent.matDrawer.close();
  }
  /**
   * Toggle edit mode
   * @param editMode
   */
  toggleEditMode(editMode: boolean | null = null): void {
    this.patchForm();

    if (editMode === null) {
      this.editMode = !this.editMode;
    } else {
      this.editMode = editMode;
    }
    /**
     * Mark for check
     */
    this._changeDetectorRef.markForCheck();
  }

  /**
   * Update the position
   */
  updatePosition(): void {
    /**
     * Get the position
     */
    const id_user_ = this.data.user.id_user;
    let position = this.positionForm.getRawValue();
    /**
     * Delete whitespace (trim() the atributes type string)
     */
    position = {
      ...position,
      id_user_: parseInt(id_user_),
      id_position: parseInt(position.id_position),
      company: {
        id_company: parseInt(position.id_company),
      },
    };
    /**
     * Update
     */
    this._positionService
      .update(position)
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe({
        next: (_position: Position) => {
          console.log(_position);
          if (_position) {
            this._notificationService.success(
              'Cargo actualizada correctamente'
            );
            /**
             * Toggle the edit mode off
             */
            this.toggleEditMode(false);
          } else {
            this._notificationService.error(
              '¡Error interno!, consulte al administrador.'
            );
          }
        },
        error: (error: { error: MessageAPI }) => {
          console.log(error);
          this._notificationService.error(
            !error.error
              ? '¡Error interno!, consulte al administrador.'
              : !error.error.description
              ? '¡Error interno!, consulte al administrador.'
              : error.error.description
          );
        },
      });
  }
  /**
   * Delete the position
   */
  deletePosition(): void {
    this._angelConfirmationService
      .open({
        title: 'Eliminar cargo',
        message:
          '¿Estás seguro de que deseas eliminar esta cargo? ¡Esta acción no se puede deshacer!',
      })
      .afterClosed()
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((confirm: ActionAngelConfirmation) => {
        if (confirm === 'confirmed') {
          /**
           * Get the current position's id
           */
          const id_user_ = this.data.user.id_user;
          const id_position = this.position.id_position;
          /**
           * Get the next/previous position's id
           */
          const currentIndex = this.positions.findIndex(
            (item) => item.id_position === id_position
          );

          const nextIndex =
            currentIndex +
            (currentIndex === this.positions.length - 1 ? -1 : 1);
          const nextId =
            this.positions.length === 1 &&
            this.positions[0].id_position === id_position
              ? null
              : this.positions[nextIndex].id_position;
          /**
           * Delete
           */
          this._positionService
            .delete(id_user_, id_position)
            .pipe(takeUntil(this._unsubscribeAll))
            .subscribe({
              next: (response: boolean) => {
                console.log(response);
                if (response) {
                  /**
                   * Return if the position wasn't deleted...
                   */
                  this._notificationService.success(
                    'Cargo eliminada correctamente'
                  );
                  /**
                   * Get the current activated route
                   */
                  let route = this._activatedRoute;
                  while (route.firstChild) {
                    route = route.firstChild;
                  }
                  /**
                   * Navigate to the next position if available
                   */
                  if (nextId) {
                    this._router.navigate(['../', nextId], {
                      relativeTo: route,
                    });
                  } else {
                    /**
                     * Otherwise, navigate to the parent
                     */
                    this._router.navigate(['../'], { relativeTo: route });
                  }
                  /**
                   * Toggle the edit mode off
                   */
                  this.toggleEditMode(false);
                } else {
                  this._notificationService.error(
                    '¡Error interno!, consulte al administrador.'
                  );
                }
              },
              error: (error: { error: MessageAPI }) => {
                console.log(error);
                this._notificationService.error(
                  !error.error
                    ? '¡Error interno!, consulte al administrador.'
                    : !error.error.description
                    ? '¡Error interno!, consulte al administrador.'
                    : error.error.description
                );
              },
            });
          /**
           * Mark for check
           */
          this._changeDetectorRef.markForCheck();
        }
        this._layoutService.setOpenModal(false);
      });
  }
}
