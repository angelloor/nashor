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
import { AttachedService } from '../attached.service';
import { Attached } from '../attached.types';
import { AttachedListComponent } from '../list/list.component';

@Component({
  selector: 'attached-details',
  templateUrl: './details.component.html',
  animations: angelAnimations,
})
export class AttachedDetailsComponent implements OnInit {
  nameEntity: string = 'Anexo';
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
  attached!: Attached;
  attachedForm!: FormGroup;
  private attacheds!: Attached[];

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
    private _attachedListComponent: AttachedListComponent,
    private _attachedService: AttachedService,
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
    this._attachedListComponent.matDrawer.open();
    /**
     * Create the attached form
     */
    this.attachedForm = this._formBuilder.group({
      id_attached: [''],
      id_company: [''],
      name_attached: ['', [Validators.required, Validators.maxLength(100)]],
      description_attached: [
        '',
        [Validators.required, Validators.maxLength(250)],
      ],
      length_mb_attached: ['', [Validators.required, Validators.maxLength(5)]],
      required_attached: ['', [Validators.required]],
    });
    /**
     * Get the attacheds
     */
    this._attachedService.attacheds$
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((attacheds: Attached[]) => {
        this.attacheds = attacheds;
        /**
         * Mark for check
         */
        this._changeDetectorRef.markForCheck();
      });
    /**
     * Get the attached
     */
    this._attachedService.attached$
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((attached: Attached) => {
        /**
         * Open the drawer in case it is closed
         */
        this._attachedListComponent.matDrawer.open();
        /**
         * Get the attached
         */
        this.attached = attached;

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
    this.attachedForm.patchValue({
      ...this.attached,
      id_company: this.attached.company.id_company,
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
    return this._attachedListComponent.matDrawer.close();
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
   * Update the attached
   */
  updateAttached(): void {
    /**
     * Get the attached
     */
    const id_user_ = this.data.user.id_user;
    let attached = this.attachedForm.getRawValue();
    /**
     * Delete whitespace (trim() the atributes type string)
     */
    attached = {
      ...attached,
      id_user_: parseInt(id_user_),
      id_attached: parseInt(attached.id_attached),
      length_mb_attached: parseInt(attached.length_mb_attached),
      company: {
        id_company: parseInt(attached.id_company),
      },
    };
    /**
     * Update
     */
    this._attachedService
      .update(attached)
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe({
        next: (_attached: Attached) => {
          if (_attached) {
            this._notificationService.success(
              'Anexo actualizada correctamente'
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
   * Delete the attached
   */
  deleteAttached(): void {
    this._angelConfirmationService
      .open({
        title: 'Eliminar anexo',
        message:
          '¿Estás seguro de que deseas eliminar esta anexo? ¡Esta acción no se puede deshacer!',
      })
      .afterClosed()
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((confirm: ActionAngelConfirmation) => {
        if (confirm === 'confirmed') {
          /**
           * Get the current attached's id
           */
          const id_user_ = this.data.user.id_user;
          const id_attached = this.attached.id_attached;
          /**
           * Get the next/previous attached's id
           */
          const currentIndex = this.attacheds.findIndex(
            (item) => item.id_attached === id_attached
          );

          const nextIndex =
            currentIndex +
            (currentIndex === this.attacheds.length - 1 ? -1 : 1);
          const nextId =
            this.attacheds.length === 1 &&
            this.attacheds[0].id_attached === id_attached
              ? null
              : this.attacheds[nextIndex].id_attached;
          /**
           * Delete
           */
          this._attachedService
            .delete(id_user_, id_attached)
            .pipe(takeUntil(this._unsubscribeAll))
            .subscribe({
              next: (response: boolean) => {
                if (response) {
                  /**
                   * Return if the attached wasn't deleted...
                   */
                  this._notificationService.success(
                    'Anexo eliminada correctamente'
                  );
                  /**
                   * Get the current activated route
                   */
                  let route = this._activatedRoute;
                  while (route.firstChild) {
                    route = route.firstChild;
                  }
                  /**
                   * Navigate to the next attached if available
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
