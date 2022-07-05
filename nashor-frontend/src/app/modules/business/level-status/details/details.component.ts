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
import { NotificationService } from 'app/shared/notification/notification.service';
import { filter, fromEvent, merge, Subject, takeUntil } from 'rxjs';
import { LevelStatusService } from '../level-status.service';
import { LevelStatus } from '../level-status.types';
import { LevelStatusListComponent } from '../list/list.component';

@Component({
  selector: 'level-status-details',
  templateUrl: './details.component.html',
  animations: angelAnimations,
})
export class LevelStatusDetailsComponent implements OnInit {
  nameEntity: string = 'Estado del nivel';
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
  levelStatus!: LevelStatus;
  levelStatusForm!: FormGroup;
  private levelStatuss!: LevelStatus[];

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
    private _levelStatusListComponent: LevelStatusListComponent,
    private _levelStatusService: LevelStatusService,
    @Inject(DOCUMENT) private _document: any,
    private _formBuilder: FormBuilder,
    private _activatedRoute: ActivatedRoute,
    private _router: Router,
    private _notificationService: NotificationService,
    private _angelConfirmationService: AngelConfirmationService,
    private _layoutService: LayoutService
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
    this._levelStatusListComponent.matDrawer.open();
    /**
     * Create the levelStatus form
     */
    this.levelStatusForm = this._formBuilder.group({
      id_level_status: [''],
      id_company: [''],
      name_level_status: ['', [Validators.required, Validators.maxLength(100)]],
      description_level_status: [
        '',
        [Validators.required, Validators.maxLength(250)],
      ],
      color_level_status: ['', [Validators.required, Validators.maxLength(9)]],
    });
    /**
     * Get the levelStatuss
     */
    this._levelStatusService.levelStatuss$
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((levelStatuss: LevelStatus[]) => {
        this.levelStatuss = levelStatuss;
        /**
         * Mark for check
         */
        this._changeDetectorRef.markForCheck();
      });
    /**
     * Get the levelStatus
     */
    this._levelStatusService.levelStatus$
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((levelStatus: LevelStatus) => {
        /**
         * Open the drawer in case it is closed
         */
        this._levelStatusListComponent.matDrawer.open();
        /**
         * Get the levelStatus
         */
        this.levelStatus = levelStatus;

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
    this.levelStatusForm.patchValue({
      ...this.levelStatus,
      id_company: this.levelStatus.company.id_company,
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
    return this._levelStatusListComponent.matDrawer.close();
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
   * Update the levelStatus
   */
  updateLevelStatus(): void {
    /**
     * Get the levelStatus
     */
    const id_user_ = this.data.user.id_user;
    let levelStatus = this.levelStatusForm.getRawValue();
    /**
     * Delete whitespace (trim() the atributes type string)
     */
    levelStatus = {
      ...levelStatus,
      id_user_: parseInt(id_user_),
      id_level_status: parseInt(levelStatus.id_level_status),
      company: {
        id_company: parseInt(levelStatus.id_company),
      },
    };
    /**
     * Update
     */
    this._levelStatusService
      .update(levelStatus)
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe({
        next: (_levelStatus: LevelStatus) => {
          console.log(_levelStatus);
          if (_levelStatus) {
            this._notificationService.success(
              'Estado del nivel actualizada correctamente'
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
   * Delete the levelStatus
   */
  deleteLevelStatus(): void {
    this._angelConfirmationService
      .open({
        title: 'Eliminar estado del nivel',
        message:
          '¿Estás seguro de que deseas eliminar esta estado del nivel? ¡Esta acción no se puede deshacer!',
      })
      .afterClosed()
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((confirm: ActionAngelConfirmation) => {
        if (confirm === 'confirmed') {
          /**
           * Get the current levelStatus's id
           */
          const id_user_ = this.data.user.id_user;
          const id_level_status = this.levelStatus.id_level_status;
          /**
           * Get the next/previous levelStatus's id
           */
          const currentIndex = this.levelStatuss.findIndex(
            (item) => item.id_level_status === id_level_status
          );

          const nextIndex =
            currentIndex +
            (currentIndex === this.levelStatuss.length - 1 ? -1 : 1);
          const nextId =
            this.levelStatuss.length === 1 &&
            this.levelStatuss[0].id_level_status === id_level_status
              ? null
              : this.levelStatuss[nextIndex].id_level_status;
          /**
           * Delete
           */
          this._levelStatusService
            .delete(id_user_, id_level_status)
            .pipe(takeUntil(this._unsubscribeAll))
            .subscribe({
              next: (response: boolean) => {
                console.log(response);
                if (response) {
                  /**
                   * Return if the levelStatus wasn't deleted...
                   */
                  this._notificationService.success(
                    'Estado del nivel eliminada correctamente'
                  );
                  /**
                   * Get the current activated route
                   */
                  let route = this._activatedRoute;
                  while (route.firstChild) {
                    route = route.firstChild;
                  }
                  /**
                   * Navigate to the next levelStatus if available
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
