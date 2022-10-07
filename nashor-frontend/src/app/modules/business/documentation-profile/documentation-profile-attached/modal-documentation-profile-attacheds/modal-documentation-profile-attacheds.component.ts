import {
  ActionAngelConfirmation,
  AngelConfirmationService,
} from '@angel/services/confirmation';
import { OverlayRef } from '@angular/cdk/overlay';
import { ChangeDetectorRef, Component, Inject, OnInit } from '@angular/core';
import {
  FormArray,
  FormBuilder,
  FormControl,
  FormGroup,
  Validators,
} from '@angular/forms';
import { MAT_DIALOG_DATA } from '@angular/material/dialog';
import { Store } from '@ngrx/store';
import { AppInitialData, MessageAPI } from 'app/core/app/app.type';
import { LayoutService } from 'app/layout/layout.service';
import { AttachedService } from 'app/modules/business/attached/attached.service';
import { Attached } from 'app/modules/business/attached/attached.types';
import { ModalAttachedsService } from 'app/modules/business/attached/modal-attacheds/modal-attacheds.service';
import { NotificationService } from 'app/shared/notification/notification.service';
import { cloneDeep } from 'lodash';
import { Subject, takeUntil } from 'rxjs';
import { DocumentationProfileService } from '../../documentation-profile.service';
import { DocumentationProfile } from '../../documentation-profile.types';
import { DocumentationProfileAttachedService } from '../documentation-profile-attached.service';
import { DocumentationProfileAttached } from '../documentation-profile-attached.types';
import { ModalDocumentationProfileAttachedsService } from './modal-documentation-profile-attacheds.service';

@Component({
  selector: 'app-modal-documentation-profile-attacheds',
  templateUrl: './modal-documentation-profile-attacheds.component.html',
  styleUrls: ['./modal-documentation-profile-attacheds.component.scss'],
})
export class ModalDocumentationProfileAttachedsComponent implements OnInit {
  private data!: AppInitialData;

  id_company: string = '';

  id_documentation_profile: string = '';

  editMode: boolean = false;

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
    @Inject(MAT_DIALOG_DATA) public _data: any,
    private _store: Store<{ global: AppInitialData }>,
    private _changeDetectorRef: ChangeDetectorRef,
    private _documentationProfileService: DocumentationProfileService,
    private _formBuilder: FormBuilder,
    private _notificationService: NotificationService,
    private _angelConfirmationService: AngelConfirmationService,
    private _layoutService: LayoutService,
    private _documentationProfileAttachedService: DocumentationProfileAttachedService,
    private _attachedService: AttachedService,
    private _modalDocumentationProfileAttachedsService: ModalDocumentationProfileAttachedsService,
    private _modalAttachedsService: ModalAttachedsService
  ) {}

  /** ----------------------------------------------------------------------------------------------------- */
  /** @ Lifecycle hooks
	  /** ----------------------------------------------------------------------------------------------------- */

  /**
   * On init
   */
  ngOnInit(): void {
    this.id_documentation_profile = this._data.id_documentation_profile;
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
    this._documentationProfileService
      .specificRead(this.id_documentation_profile)
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe();
    /**
     * Get the documentationProfile
     */
    this._documentationProfileService.documentationProfile$
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((documentationProfile: DocumentationProfile) => {
        /**
         * Get the documentationProfile
         */
        this.documentationProfile = documentationProfile;

        /**
         * byDocumentationProfileRead
         */

        if (documentationProfile.id_documentation_profile != ' ') {
          this._documentationProfileAttachedService
            .byDocumentationProfileRead(
              documentationProfile.id_documentation_profile
            )
            .pipe(takeUntil(this._unsubscribeAll))
            .subscribe();
        }

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
                              disabled: false,
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

                  // this.documentationProfileAttached.length !=
                  // index + 1 || this.isSelectedAll,

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
         * Mark for check
         */
        this._changeDetectorRef.markForCheck();
      });
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
  /**
   * closeModalDocumentationProfileAttacheds
   */
  closeModalDocumentationProfileAttacheds(): void {
    this._modalDocumentationProfileAttachedsService.closeModalDocumentationProfileAttacheds();
  }
  /**
   * openModalAttacheds
   */
  openModalAttacheds(): void {
    this._modalAttachedsService.openModalAttacheds();
  }
  trackByFn(index: number, item: any): any {
    return item.id || index;
  }
}
