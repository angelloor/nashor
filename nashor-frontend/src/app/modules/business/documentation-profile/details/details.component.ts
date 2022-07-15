import { angelAnimations } from '@angel/animations';
import { AngelAlertType } from '@angel/components/alert';
import {
  ActionAngelConfirmation,
  AngelConfirmationService,
} from '@angel/services/confirmation';
import { OverlayRef } from '@angular/cdk/overlay';
import { DOCUMENT } from '@angular/common';
import { ChangeDetectorRef, Component, Inject, OnInit } from '@angular/core';
import {
  FormArray,
  FormBuilder,
  FormControl,
  FormGroup,
  Validators,
} from '@angular/forms';
import { MatDrawerToggleResult } from '@angular/material/sidenav';
import { ActivatedRoute, Router } from '@angular/router';
import { Store } from '@ngrx/store';
import { AppInitialData, MessageAPI } from 'app/core/app/app.type';
import { LayoutService } from 'app/layout/layout.service';
import { NotificationService } from 'app/shared/notification/notification.service';
import { cloneDeep } from 'lodash';
import { filter, fromEvent, merge, Subject, takeUntil } from 'rxjs';
import { AttachedService } from '../../attached/attached.service';
import { Attached } from '../../attached/attached.types';
import { DocumentationProfileAttachedService } from '../documentation-profile-attached/documentation-profile-attached.service';
import { DocumentationProfileAttached } from '../documentation-profile-attached/documentation-profile-attached.types';
import { DocumentationProfileService } from '../documentation-profile.service';
import { DocumentationProfile } from '../documentation-profile.types';
import { DocumentationProfileListComponent } from '../list/list.component';

@Component({
  selector: 'documentation-profile-details',
  templateUrl: './details.component.html',
  animations: angelAnimations,
})
export class DocumentationProfileDetailsComponent implements OnInit {
  nameEntity: string = 'Perfil de documentación';
  private data!: AppInitialData;
  id_company: string = '';

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
  documentationProfile!: DocumentationProfile;
  documentationProfileForm!: FormGroup;
  private documentationProfiles!: DocumentationProfile[];

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
   * DocumentationProfileAttached
   */
  listAttached: Attached[] = [];
  isSelectedAll: boolean = false;

  documentationProfileAttached: DocumentationProfileAttached[] = [];
  /**
   * DocumentationProfileAttached
   */
  /**
   * Constructor
   */
  constructor(
    private _store: Store<{ global: AppInitialData }>,
    private _changeDetectorRef: ChangeDetectorRef,
    private _documentationProfileListComponent: DocumentationProfileListComponent,
    private _documentationProfileService: DocumentationProfileService,
    @Inject(DOCUMENT) private _document: any,
    private _formBuilder: FormBuilder,
    private _activatedRoute: ActivatedRoute,
    private _router: Router,
    private _notificationService: NotificationService,
    private _angelConfirmationService: AngelConfirmationService,
    private _layoutService: LayoutService,
    private _documentationProfileAttachedService: DocumentationProfileAttachedService,
    private _attachedService: AttachedService
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
      this.id_company = this.data.user.company.id_company;
    });
    /**
     * Open the drawer
     */
    this._documentationProfileListComponent.matDrawer.open();
    /**
     * Create the documentationProfile form
     */
    this.documentationProfileForm = this._formBuilder.group({
      id_documentation_profile: [''],
      id_company: ['', [Validators.required]],
      name_documentation_profile: [
        '',
        [Validators.required, Validators.maxLength(100)],
      ],
      description_documentation_profile: [
        '',
        [Validators.required, Validators.maxLength(250)],
      ],
      status_documentation_profile: ['', [Validators.required]],
      attacheds: this._formBuilder.array([]),
    });
    /**
     * Get the documentationProfiles
     */
    this._documentationProfileService.documentationProfiles$
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((documentationProfiles: DocumentationProfile[]) => {
        this.documentationProfiles = documentationProfiles;
        /**
         * Mark for check
         */
        this._changeDetectorRef.markForCheck();
      });
    /**
     * Get the documentationProfile
     */
    this._documentationProfileService.documentationProfile$
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((documentationProfile: DocumentationProfile) => {
        /**
         * Open the drawer in case it is closed
         */
        this._documentationProfileListComponent.matDrawer.open();
        /**
         * Get the documentationProfile
         */
        this.documentationProfile = documentationProfile;

        /**
         * byDocumentationProfileRead
         */
        this._documentationProfileAttachedService
          .byDocumentationProfileRead(
            documentationProfile.id_documentation_profile
          )
          .pipe(takeUntil(this._unsubscribeAll))
          .subscribe();

        /**
         * get selected attached
         */
        this._attachedService
          .byCompanyQueryRead(this.id_company, '*')
          .pipe(takeUntil(this._unsubscribeAll))
          .subscribe((attached: Attached[]) => {
            this.listAttached = attached;
            /**
             *Subscribe to documentationProfileAttacheds
             */
            this._documentationProfileAttachedService.documentationProfileAttacheds$
              .pipe(takeUntil(this._unsubscribeAll))
              .subscribe(
                (
                  documentationProfileAttached: DocumentationProfileAttached[]
                ) => {
                  this.documentationProfileAttached =
                    documentationProfileAttached;

                  if (
                    this.documentationProfileAttached.length ==
                    this.listAttached.length
                  ) {
                    this.isSelectedAll = true;
                  } else {
                    this.isSelectedAll = false;
                  }
                  /**
                   * Filter select
                   */
                  /**
                   * Reset the selection
                   * 1) add attribute isSelected
                   * 2) [disabled]="entity.isSelected" in mat-option
                   */
                  this.listAttached.map((item, index) => {
                    item = {
                      ...item,
                      isSelected: false,
                    };
                    this.listAttached[index] = item;
                  });

                  let filterCategoriesAttacheds: Attached[] = cloneDeep(
                    this.listAttached
                  );
                  /**
                   * Selected Items
                   */
                  this.documentationProfileAttached.map((itemOne) => {
                    /**
                     * All Items
                     */
                    filterCategoriesAttacheds.map((itemTwo, index) => {
                      if (
                        itemTwo.id_attached == itemOne.attached!.id_attached
                      ) {
                        itemTwo = {
                          ...itemTwo,
                          isSelected: true,
                        };

                        filterCategoriesAttacheds[index] = itemTwo;
                      }
                    });
                  });

                  this.listAttached = filterCategoriesAttacheds;
                  /**
                   * Filter select
                   */

                  /**
                   * Clear the attacheds form arrays
                   */
                  (
                    this.documentationProfileForm.get('attacheds') as FormArray
                  ).clear();

                  const attachedsFormGroups: any = [];

                  /**
                   * Iterate through them
                   */
                  this.documentationProfileAttached.forEach(
                    (_attached, index: number) => {
                      /**
                       * Create an attached form group
                       */
                      attachedsFormGroups.push(
                        this._formBuilder.group({
                          id_documentation_profile_attached: [
                            _attached.id_documentation_profile_attached,
                          ],
                          name_attached: [
                            {
                              value: _attached.attached!.name_attached,
                              disabled:
                                this.documentationProfileAttached.length !=
                                  index + 1 || this.isSelectedAll,
                            },
                          ],
                          attached: [_attached.attached],
                          documentation_profile: [
                            _attached.documentation_profile,
                          ],
                        })
                      );
                    }
                  );

                  /**
                   * Add the attacheds form groups to the attacheds form array
                   */
                  attachedsFormGroups.forEach((attachedsFormGroup: any) => {
                    (
                      this.documentationProfileForm.get(
                        'attacheds'
                      ) as FormArray
                    ).push(attachedsFormGroup);
                  });
                }
              );
          });

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

  get formArrayElementos(): FormArray {
    return this.documentationProfileForm.get('attacheds') as FormArray;
  }

  getFromControl(
    formArray: FormArray,
    index: number,
    control: string
  ): FormControl {
    return formArray.controls[index].get(control) as FormControl;
  }

  /**
   * Pacth the form with the information of the database
   */
  patchForm(): void {
    this.documentationProfileForm.patchValue({
      ...this.documentationProfile,
      id_company: this.documentationProfile.company.id_company,
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
    return this._documentationProfileListComponent.matDrawer.close();
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
   * Update the documentationProfile
   */
  updateDocumentationProfile(): void {
    /**
     * Get the documentationProfile
     */
    const id_user_ = this.data.user.id_user;
    let documentationProfile = this.documentationProfileForm.getRawValue();
    /**
     * Delete whitespace (trim() the atributes type string)
     */
    documentationProfile = {
      ...documentationProfile,
      id_user_: parseInt(id_user_),
      id_documentation_profile: parseInt(
        documentationProfile.id_documentation_profile
      ),
      company: {
        id_company: parseInt(documentationProfile.id_company),
      },
    };
    /**
     * Update
     */
    this._documentationProfileService
      .update(documentationProfile)
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe({
        next: (_documentationProfile: DocumentationProfile) => {
          if (_documentationProfile) {
            this._notificationService.success(
              'Perfil de documentación actualizada correctamente'
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
   * Delete the documentationProfile
   */
  deleteDocumentationProfile(): void {
    this._angelConfirmationService
      .open({
        title: 'Eliminar perfil de documentación',
        message:
          '¿Estás seguro de que deseas eliminar esta perfil de documentación? ¡Esta acción no se puede deshacer!',
      })
      .afterClosed()
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((confirm: ActionAngelConfirmation) => {
        if (confirm === 'confirmed') {
          /**
           * Get the current documentationProfile's id
           */
          const id_user_ = this.data.user.id_user;
          const id_documentation_profile =
            this.documentationProfile.id_documentation_profile;
          /**
           * Get the next/previous documentationProfile's id
           */
          const currentIndex = this.documentationProfiles.findIndex(
            (item) => item.id_documentation_profile === id_documentation_profile
          );

          const nextIndex =
            currentIndex +
            (currentIndex === this.documentationProfiles.length - 1 ? -1 : 1);
          const nextId =
            this.documentationProfiles.length === 1 &&
            this.documentationProfiles[0].id_documentation_profile ===
              id_documentation_profile
              ? null
              : this.documentationProfiles[nextIndex].id_documentation_profile;
          /**
           * Delete
           */
          this._documentationProfileService
            .delete(id_user_, id_documentation_profile)
            .pipe(takeUntil(this._unsubscribeAll))
            .subscribe({
              next: (response: boolean) => {
                if (response) {
                  /**
                   * Return if the documentationProfile wasn't deleted...
                   */
                  this._notificationService.success(
                    'Perfil de documentación eliminada correctamente'
                  );
                  /**
                   * Get the current activated route
                   */
                  let route = this._activatedRoute;
                  while (route.firstChild) {
                    route = route.firstChild;
                  }
                  /**
                   * Navigate to the next documentationProfile if available
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
  /**
   * Add an empty attached field
   */
  addAttachedField(): void {
    const id_user = this.data.user.id_user;
    const id_documentation_profile =
      this.documentationProfile.id_documentation_profile;

    this._documentationProfileAttachedService
      .create(id_user, id_documentation_profile)
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe({
        next: (response) => {
          if (response) {
            this._notificationService.success('Anexo agregado correctamente');
          } else {
            this._notificationService.error(
              'Ocurrió un error agregando el anexo'
            );
          }
          /**
           * Mark for check
           */
          this._changeDetectorRef.markForCheck();
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

  updateAttachedField(index: number) {
    const attachedsFormArray = this.documentationProfileForm.get(
      'attacheds'
    ) as FormArray;

    const id_user = this.data.user.id_user;
    let documentationProfileAttached = attachedsFormArray.getRawValue()[index];

    let attachedUpdate = this.listAttached.find(
      (item) => item.name_attached == documentationProfileAttached.name_attached
    );

    documentationProfileAttached = {
      ...documentationProfileAttached,
      id_user_: parseInt(id_user),
      id_documentation_profile_attached: parseInt(
        documentationProfileAttached.id_documentation_profile_attached
      ),
      documentation_profile: {
        id_documentation_profile: parseInt(
          documentationProfileAttached.documentation_profile
            .id_documentation_profile
        ),
      },
      attached: {
        id_attached: parseInt(attachedUpdate!.id_attached),
      },
    };

    delete documentationProfileAttached.name_attached;
    /**
     * Update the documentationProfileAttached
     */
    this._documentationProfileAttachedService
      .update(documentationProfileAttached)
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe({
        next: (response: any) => {
          if (response) {
            this._notificationService.success(
              'Anexo actualizado correctamente'
            );
          } else {
            this._notificationService.error(
              'Ocurrió un error actualizando el anexo'
            );
          }
          /**
           * Mark for check
           */
          this._changeDetectorRef.markForCheck();
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

  /**
   * Remove the attacheds field
   * @param index
   */
  removeAttachedField(index: number): void {
    this._angelConfirmationService
      .open({
        title: 'Eliminar perfil de documentación',
        message:
          '¿Estás seguro de que deseas eliminar este attached? ¡Esta acción no se puede deshacer!',
      })
      .afterClosed()
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((confirm: ActionAngelConfirmation) => {
        if (confirm === 'confirmed') {
          const attachedsFormArray = this.documentationProfileForm.get(
            'attacheds'
          ) as FormArray;
          /**
           * Get the current _documentationProfileAttachedService
           */
          const id_user = this.data.user.id_user;

          const idDocumentationProfileAttached =
            attachedsFormArray.getRawValue()[index]
              .id_documentation_profile_attached;
          /**
           * Delete the _documentationProfileAttachedService
           */
          this._documentationProfileAttachedService
            .delete(id_user, idDocumentationProfileAttached)
            .pipe(takeUntil(this._unsubscribeAll))
            .subscribe({
              next: (response: boolean) => {
                if (response) {
                  this._notificationService.success(
                    'Anexo eliminado correctamente'
                  );
                } else {
                  this._notificationService.error(
                    'Ocurrió un error eliminando el anexo'
                  );
                }
                /**
                 * Mark for check
                 */
                this._changeDetectorRef.markForCheck();
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
  /**
   * Track by function for ngFor loops
   * @param index
   * @param item
   */
  trackByFn(index: number, item: any): any {
    return item.id || index;
  }
}
